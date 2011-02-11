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
  end

  it 'name must be unique' do
    sponsor = Factory(:sponsored_project_sponsor)
    non_unique_project = SponsoredProjectSponsor.new(:name => sponsor.name)
    non_unique_project.should_not be_valid
  end


end