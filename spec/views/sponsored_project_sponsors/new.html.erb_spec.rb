require 'spec_helper'

describe "sponsored_project_sponsors/new.html.erb" do
  before(:each) do
    assigns[:sponsor] = stub_model(SponsoredProjectSponsor).as_new_record
  end

  it "renders new sponsor form" do
    render

    response.should have_tag("form", :action => sponsored_project_sponsors_path, :method => "post")
  end

end
