require "spec_helper"

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

  describe 'Custom Finders' do
    it "should respond to sponsors" do
      SponsoredProjectSponsor.should respond_to(:sponsors)
    end

    it "sponsors does not include archived sponsors" do
      Factory(:sponsored_project_sponsor, :is_archived => true)
      SponsoredProjectSponsor.sponsors.should be_empty
    end

    it "should respond to archived_sponsors" do
      SponsoredProjectSponsor.should respond_to(:archived_sponsors)
    end

    it "archived sponsor includes only archived sponsors" do
      archived_sponsor = Factory(:sponsored_project_sponsor, :is_archived => true)
      Factory(:sponsored_project_sponsor, :is_archived => false)
      archived_sponsors = SponsoredProjectSponsor.archived_sponsors
      archived_sponsors.length.should == 1
      archived_sponsors[0].should == archived_sponsor
    end
  end


end