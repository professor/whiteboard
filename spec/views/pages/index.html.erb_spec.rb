require 'spec_helper'

describe "pages/index.html.erb" do
  before(:each) do
    assign(:pages, [
      stub_model(Page,:url => "something"),
      stub_model(Page,:url => "something2")
    ])
  end

  it "renders a list of pages" do
    render
  end
end
