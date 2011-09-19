require 'spec_helper'

describe "pages/show.html.erb" do
  before(:each) do
    sign_in(Factory(:student_sam))
    Page.any_instance.stub(:update_search_index)
    Page.any_instance.stub(:delete_from_search)
    assign(:page, Factory(:ppm))
  end

  it "renders attributes in <p>" do
    render
  end
end
