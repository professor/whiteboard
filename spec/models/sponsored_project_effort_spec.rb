require 'spec_helper'

describe SponsoredProjectEffort do

  it 'can be created' do
    lambda {
      Factory(:sponsored_project_effort)
    }.should change(SponsoredProjectEffort, :count).by(1)
  end


  context "is not valid" do

    [:current_allocation, :year, :month, :sponsored_project_allocation_id, :confirmed].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    [:actual_allocation, :current_allocation, :year, :month].each do |attr|
      it "when #{attr} is non-numerical" do
        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => "test")
        sponsored_project_effort.should_not be_valid
      end
    end

    [:actual_allocation, :current_allocation, :year, :month].each do |attr|
      it "when #{attr} is a negative number" do
        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => -1)
        sponsored_project_effort.should_not be_valid
      end
    end

    it "when a duplicate effort for the same month, year and project allocation" do
      original = Factory(:sponsored_project_effort)
      duplicate = SponsoredProjectEffort.new()
      duplicate.month = original.month
      duplicate.year = original.year
      duplicate.sponsored_project_allocation_id = original.sponsored_project_allocation_id
      duplicate.should_not be_valid
    end
  end

  context "associations --" do
    it 'belongs to a sponsored project allocation' do
      subject.should respond_to(:sponsored_project_allocation)
    end

    it 'belongs to a sponsored project current allocation' do
      sponsored_project_people = Factory(:sponsored_project_allocation)
      sponsored_project_people.current_allocation.should_not be_nil
    end
  end

  context "with custom creators" do
    it "responds to new_from_sponsored_project_allocation" do
      SponsoredProjectEffort.should respond_to(:new_from_sponsored_project_allocation)
    end

    it "creates new from sponsored project allocation" do
      allocation = Factory(:sponsored_project_allocation)
      sponsored_project_effort = SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)

      sponsored_project_effort.current_allocation.should == allocation.current_allocation
      sponsored_project_effort.actual_allocation.should == allocation.current_allocation
      sponsored_project_effort.confirmed.should == false

      sponsored_project_effort.month.should == 1.month.ago.month
      sponsored_project_effort.year.should == 1.month.ago.year
    end

    it "won't create a duplicate for same month and allocation" do
      allocation = Factory(:sponsored_project_allocation)
      successful_sponsored_project_effort = SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)
      failed_sponsored_project_effort = SponsoredProjectEffort.new_from_sponsored_project_allocation(allocation)

      efforts = SponsoredProjectEffort.find_all_by_month_and_year_and_sponsored_project_allocation_id(1.month.ago.month, 1.month.ago.year, allocation.id)
      efforts.length.should == 1
    end
  end

  context "with named scopes" do
    before(:each) do
      @faculty_frank = Factory(:faculty_frank)
      @faculty_fagan = Factory(:faculty_fagan)

      @allocation_frank = Factory(:sponsored_project_allocation, :person => @faculty_frank)
      @allocation_fagan = Factory(:sponsored_project_allocation, :person => @faculty_fagan)

      @effort_frank = Factory(:sponsored_project_effort, :sponsored_project_allocation => @allocation_frank)
      @effort_fagan = Factory(:sponsored_project_effort, :sponsored_project_allocation => @allocation_fagan)
    end

    it "responds to month_under_inspection_for_a_given_user" do
      SponsoredProjectEffort.should respond_to(:month_under_inspection_for_a_given_user)
    end

    it "finds all effort for the current month for a given user" do
      efforts = [@effort_frank]
      SponsoredProjectEffort.month_under_inspection_for_a_given_user(@faculty_frank.id).should == efforts
    end

    it "responds to for_all_users_for_a_given_month" do
      SponsoredProjectEffort.should respond_to(:for_all_users_for_a_given_month)
    end

    it "finds all effort for the current month for all users" do
      efforts = [@effort_frank, @effort_fagan]

      SponsoredProjectEffort.for_all_users_for_a_given_month(@effort_frank.month, @effort_frank.year).should == efforts
    end    
  end

  context "emails the business manager" do

    specify { SponsoredProjectEffort.should respond_to(:emails_business_manager)}

    it "successfully" do
      @effort = Factory(:sponsored_project_effort)
      SponsoredProjectEffortMailer.should_receive(:deliver_changed_allocation_email_to_business_manager)
      SponsoredProjectEffort.emails_business_manager(@effort.id)
    end

  end



end