require 'spec_helper'

describe "sponsored_projects/index.html.erb" do
  before(:each) do
    sponsored_project = Factory.build(:sponsored_project, :id => 1)
    
    assigns[:projects] = [
      sponsored_project,
      sponsored_project
    ]
    assigns[:sponsors] = [
      stub_model(SponsoredProjectSponsor),
      stub_model(SponsoredProjectSponsor)
    ]
  end

  it "renders a list of sponsored projects" do
    render
  end
end
