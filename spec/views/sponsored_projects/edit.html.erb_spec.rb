require 'spec_helper'

describe "sponsored_projects/edit.html.erb" do
  before(:each) do
    @project = assign(:project, stub_model(SponsoredProject, :new_record? => false))
    assign(:sponsors, [Factory.build(:sponsored_project_sponsor), Factory.build(:sponsored_project_sponsor)])
  end

  it "renders edit project form" do
    render

    rendered.should have_selector("form", :action => sponsored_projects_path(@project), :method => "post")

  end

  it "renders a list of sponsors to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    rendered.should have_selector("select")
  end
end
