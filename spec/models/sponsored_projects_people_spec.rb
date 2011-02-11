require 'spec_helper'

describe SponsoredProjectsPeople do

  it 'can be created' do
    lambda {
      Factory(:sponsored_projects_people)
    }.should change(SponsoredProjectsPeople, :count).by(1)
  end

  context "is not valid" do

    [:person_id, :sponsored_project_id, :current_allocation].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    it "when current_allocation is non-numerical" do
      sponsored_project_person = Factory.build(:sponsored_projects_people, :current_allocation => "test")
      sponsored_project_person.should_not be_valid
    end

    it "when current_allocation is a negative number" do
      sponsored_project_person = Factory.build(:sponsored_projects_people, :current_allocation => -1)
      sponsored_project_person.should_not be_valid
    end
  end

  context "associations --" do
    it 'belongs to a sponsored project' do
      subject.should respond_to(:sponsored_project)
    end

    it 'belongs to a sponsored project name' do
      sponsored_project_person = Factory(:sponsored_projects_people)
      sponsored_project_person.sponsored_project.name.should_not be_empty
    end

    it 'belongs to a person' do
      subject.should respond_to(:person)
    end

    it 'belongs to a person human_name' do
      sponsored_project_person = Factory(:sponsored_projects_people)
      sponsored_project_person.person.human_name.should_not be_empty
    end


  end


end