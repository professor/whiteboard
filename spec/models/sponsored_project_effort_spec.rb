require 'spec_helper'

describe SponsoredProjectEffort do

  it 'can be created' do
    lambda {
      Factory(:sponsored_project_effort)
    }.should change(SponsoredProjectEffort, :count).by(1)
  end


  context "is not valid" do

    [:current_allocation, :year, :month, :sponsored_projects_people_id, :confirmed].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    [:current_allocation, :year, :month].each do |attr|
      it "when #{attr} is non-numerical" do
        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => "test")
        sponsored_project_effort.should_not be_valid
      end
    end

    [:current_allocation, :year, :month].each do |attr|
      it "when #{attr} is a negative number" do
        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => -1)
        sponsored_project_effort.should_not be_valid
      end
    end


    context "associations --" do
      it 'belongs to a sponsored projects people' do
        subject.should respond_to(:sponsored_projects_people)
      end

      it 'belongs to a sponsored projects people current allocation' do
        sponsored_project_people = Factory(:sponsored_projects_people)
        sponsored_project_people.current_allocation.should_not be_nil
      end
    end

  end

end