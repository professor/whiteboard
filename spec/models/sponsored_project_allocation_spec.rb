require 'spec_helper'
require "models/archived_behavior"

describe SponsoredProjectAllocation do

  it 'can be created' do
    lambda {
      FactoryGirl.create(:sponsored_project_allocation)
    }.should change(SponsoredProjectAllocation, :count).by(1)
  end

  context "is not valid" do

    [:user_id, :sponsored_project_id, :current_allocation].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    it "without is_archived" do
      subject.is_archived = nil
      subject.should_not be_valid
      subject.errors[:is_archived].should_not be_empty
    end

    it "when current_allocation is non-numerical" do
      sponsored_project_user = FactoryGirl.build(:sponsored_project_allocation, :current_allocation => "test")
      sponsored_project_user.should_not be_valid
    end

    it "when current_allocation is a negative number" do
      sponsored_project_user = FactoryGirl.build(:sponsored_project_allocation, :current_allocation => -1)
      sponsored_project_user.should_not be_valid
    end

    it "when a duplicate allocation exists for the same user to project" do
      original = FactoryGirl.create(:sponsored_project_allocation)
      duplicate = FactoryGirl.build(:sponsored_project_allocation, :user => original.user, :sponsored_project => original.sponsored_project)
      duplicate.should_not be_valid
    end
  end

  context "associations --" do
    it 'belongs to a sponsored project' do
      subject.should respond_to(:sponsored_project)
    end

    it 'belongs to a sponsored project name' do
      sponsored_project_user = FactoryGirl.create(:sponsored_project_allocation)
      sponsored_project_user.sponsored_project.name.should_not be_empty
    end

    it 'belongs to a user' do
      subject.should respond_to(:user)
    end

    it 'belongs to a user human_name' do
      sponsored_project_user = FactoryGirl.create(:sponsored_project_allocation)
      sponsored_project_user.user.human_name.should_not be_empty
    end


  end


  describe "objects" do
    before(:each) do
      @archived = FactoryGirl.create(:sponsored_project_allocation, :is_archived => true)
      @current = FactoryGirl.create(:sponsored_project_allocation, :is_archived => false, :user => @archived.user)
    end

    it_should_behave_like "archived objects"
  end

  context "creates monthly copy to sponsored project effort" do

    before(:each) do
      @faculty_fagan = FactoryGirl.create(:faculty_fagan)
      @faculty_frank = FactoryGirl.create(:faculty_frank)
      @project_rover = FactoryGirl.create(:sponsored_project, :name => "Rover SW")
      @project_disaster = FactoryGirl.create(:sponsored_project, :name => "Disaster Response")
      @allocation_fagan_rover = FactoryGirl.create(:sponsored_project_allocation, :user => @faculty_fagan, :current_allocation => 50, :sponsored_project => @project_rover)
      @allocation_fagan_disaster = FactoryGirl.create(:sponsored_project_allocation, :user => @faculty_fagan, :current_allocation => 50, :sponsored_project => @project_disaster)
    end

    it 'responds to monthly_copy_to_sponsored_project_effort' do
      SponsoredProjectAllocation.should respond_to(:monthly_copy_to_sponsored_project_effort)
    end

    it 'of unique allocations even if it is executed twice in the same month' do
      lambda {
        SponsoredProjectAllocation.monthly_copy_to_sponsored_project_effort
        SponsoredProjectAllocation.monthly_copy_to_sponsored_project_effort
        }.should change(SponsoredProjectEffort, :count).by(2) 
    end

    it 'does not copy archived allocations' do
      @project_fading_shiny_newness = FactoryGirl.create(:sponsored_project, :name => "Last Year's Hot Thing'")
      @allocation_fagan_archived = FactoryGirl.create(:sponsored_project_allocation, :user => @faculty_fagan, :current_allocation => 50, :is_archived => true, :sponsored_project => @project_fading_shiny_newness)
      lambda {
        SponsoredProjectAllocation.monthly_copy_to_sponsored_project_effort
        }.should change(SponsoredProjectEffort, :count).by(2)
    end
  end

  context "emails staff to confirm their effort for current month" do

    before do
      @faculty_frank = FactoryGirl.create(:faculty_frank_user)
      @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)

      @allocation_frank = FactoryGirl.create(:sponsored_project_allocation, :user => @faculty_frank)
      @allocation_fagan = FactoryGirl.create(:sponsored_project_allocation, :user => @faculty_fagan)

      @effort_frank = FactoryGirl.create(:sponsored_project_effort, :sponsored_project_allocation => @allocation_frank)
      @effort_fagan = FactoryGirl.create(:sponsored_project_effort, :sponsored_project_allocation => @allocation_fagan)
    end

    specify { SponsoredProjectAllocation.should respond_to(:emails_staff_requesting_confirmation_for_allocations)}

    it 'should email faculty that have not confirmed, but not email faculty that have already confirmed' do
      @effort_frank.confirmed = false
      @effort_frank.save
      @effort_fagan.confirmed = true
      @effort_fagan.save

      mailer = double("mailer")
      mailer.stub(:deliver)
      SponsoredProjectEffortMailer.should_receive(:monthly_staff_email).with(@faculty_frank, @effort_frank.month, @effort_frank.year).and_return(mailer)
      SponsoredProjectEffortMailer.should_not_receive(:monthly_staff_email).with(@faculty_fagan, @effort_fagan.month, @effort_fagan.year)
      SponsoredProjectAllocation.emails_staff_requesting_confirmation_for_allocations
    end

    it 'should not email faculty who have been emailed recently' do
      @effort_frank.confirmed == false
      @effort_frank.save
      @faculty_frank.sponsored_project_effort_last_emailed = Date.today - 20
      @faculty_frank.save

      @effort_fagan.confirmed == false
      @effort_fagan.save
      @faculty_fagan.sponsored_project_effort_last_emailed = 1.hour.ago
      @faculty_fagan.save

      mailer = double("mailer")
      mailer.stub(:deliver)
      SponsoredProjectEffortMailer.should_receive(:monthly_staff_email).with(@faculty_frank, @effort_frank.month, @effort_frank.year).and_return(mailer)
      SponsoredProjectEffortMailer.should_not_receive(:monthly_staff_email).with(@faculty_fagan, @effort_fagan.month, @effort_fagan.year)
      SponsoredProjectAllocation.emails_staff_requesting_confirmation_for_allocations
    end

  end

end