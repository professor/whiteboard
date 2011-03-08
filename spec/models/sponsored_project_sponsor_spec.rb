require "spec_helper"
require "models/archived_behavior"

describe SponsoredProjectSponsor do

  it 'can be created' do
    lambda {
      Factory(:sponsored_project_sponsor)
    }.should change(SponsoredProjectSponsor, :count).by(1)
  end

  context "is not valid" do

    [:name].each do |attr|
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
    sponsor = Factory(:sponsored_project_sponsor)
    non_unique_project = SponsoredProjectSponsor.new(:name => sponsor.name)
    non_unique_project.should_not be_valid
  end


  describe "objects" do
    before(:each) do
       @archived =  Factory(:sponsored_project_sponsor, :is_archived => true)
       @current =  Factory(:sponsored_project_sponsor, :is_archived => false)
    end

    it_should_behave_like "archived objects"
  end  


end