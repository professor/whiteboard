require 'spec_helper'

describe "pages/index.html.erb" do
  before(:each) do
    assigns[:pages] = [
      stub_model(Page),
      stub_model(Page)
    ]
# rspec 2
#    assign(:pages, [
#      stub_model(Page),
#      stub_model(Page)
#    ])
  end

  it "renders a list of pages" do
    render
  end
end
