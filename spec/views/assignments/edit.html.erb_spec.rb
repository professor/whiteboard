require 'spec_helper'

describe "assignments/edit.html.erb" do
  before(:each) do
    @assignment = assign(:assignment, stub_model(Assignment))
  end

  it "renders the edit assignment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => assignments_path(@assignment), :method => "post" do
    end
  end
end
