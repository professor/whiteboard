require 'spec_helper'

describe "sponsored_projects/new.html.erb" do
  before(:each) do
    assign(:project, stub_model(SponsoredProject).as_new_record)

    assign(:sponsors, [Factory.build(:sponsored_project_sponsor), Factory.build(:sponsored_project_sponsor)])
  end

  it "renders new project form" do
    render

    rendered.should have_selector("form", :action => sponsored_projects_path, :method => "post")
  end

  it "renders a list of sponsors to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    rendered.should have_selector("select")
  end
end
