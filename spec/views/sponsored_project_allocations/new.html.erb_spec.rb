require 'spec_helper'

describe "sponsored_project_allocations/new" do

  before(:each) do
    assign(:allocation, stub_model(SponsoredProjectAllocation).as_new_record)

    assign(:projects, [Factory.build(:sponsored_project)])
    assign(:people, [Factory.build(:faculty_frank), Factory.build(:admin_andy)])
  end

  it "renders new allocation form" do
    render

    rendered.should have_selector("form", :action => sponsored_project_allocations_path, :method => "post")
  end

  it "renders a list of projects to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    rendered.should have_selector("select")
  end

  it "renders a list of people to pick from" do
    #Todo , make this test more interesting in rails 3
    render

    rendered.should have_selector("select")
  end

end