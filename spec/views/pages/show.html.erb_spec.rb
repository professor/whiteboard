require 'spec_helper'

describe "pages/show.html.erb" do
  before(:each) do
    login_user(Factory(:student_sam))
    assigns[:page] = Factory(:ppm) #rspec 1?
#rspec 2?    @page = assign(:page, Factory(:ppm))
  end

  it "renders attributes in <p>" do
    render
  end
end
