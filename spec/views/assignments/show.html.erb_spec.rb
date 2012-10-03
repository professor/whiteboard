require 'spec_helper'

describe "assignments/show.html.erb" do
  before(:each) do
    @assignment = assign(:assignment, stub_model(Assignment))
  end

  it "renders attributes in <p>" do
    render
  end
end
