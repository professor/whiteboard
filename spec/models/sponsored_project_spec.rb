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


end