require 'spec_helper'

describe "pages/show.html.erb" do
  before(:each) do
    login_user(Factory(:student_sam))
    assign(:page, Factory(:ppm))
  end

  it "renders attributes in <p>" do
    render
  end
end
