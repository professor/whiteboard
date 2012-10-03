require 'spec_helper'

describe "assignments/new.html.erb" do
  before(:each) do
    assign(:assignment, stub_model(Assignment).as_new_record)
  end

  it "renders new assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assignments_path, :method => "post" do
    end
  end
end
