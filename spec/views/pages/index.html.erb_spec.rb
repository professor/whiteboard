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
  
  it "renders a question if flash[:new_page] is set" do
    flash[:new_page] = 'some_new_page_title'
    render :template => 'pages/index.html.erb', :layout => 'layouts/cmu_sv'
    rendered.should include("Would you like to create it?")
  end
end
