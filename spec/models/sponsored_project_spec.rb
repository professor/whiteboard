require 'spec_helper'

describe SponsoredProject do

  it 'can be created' do
    lambda {
      Factory(:sponsored_project)
    }.should change(SponsoredProject, :count).by(1)
  end

  context "is not valid" do

    [:name, :sponsor_id].each do |attr|
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
  end

  it 'name must be unique' do
    project = Factory(:sponsored_project)
    non_unique_project = SponsoredProject.new(:name => project.name)
    non_unique_project.should_not be_valid
  end
  

  context "associations --" do
    it 'belongs to sponsor' do
      subject.should respond_to(:sponsor)
    end

    it 'belongs to a sponsor name' do
      project = Factory(:sponsored_project)
      project.save
      project.sponsor.name.should_not be_empty
    end
  end

  describe 'Custom Finders' do
    it "should respond to projects" do
      SponsoredProject.should respond_to(:projects)
    end

    it "projects does not include archived projects" do
      Factory(:sponsored_project, :is_archived => true)
      SponsoredProject.projects.should be_empty
    end

    it "should respond to archived_projects" do
      SponsoredProject.should respond_to(:archived_projects)
    end

    it "archived projects includes only archived projects" do
      archived_project = Factory(:sponsored_project, :is_archived => true)
      Factory(:sponsored_project, :is_archived => false)
      archived_projects = SponsoredProject.archived_projects
      archived_projects.length.should == 1
      archived_projects[0].should == archived_project
    end
  end


end