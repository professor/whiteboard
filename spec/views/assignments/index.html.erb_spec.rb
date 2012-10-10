require 'spec_helper'

describe "assignments/index.html.erb" do
  before(:each) do
    assign(:assignments, [
      stub_model(Assignment),
      stub_model(Assignment)
    ])
  end

  xit "renders a list of assignments" do
    render
  end
end
