require 'spec_helper'

describe "pages/new.html.erb" do
  before(:each) do
#    assigns[:page] = Factory(:ppm) #rspec 1?
    login_user(Factory(:faculty_frank))
    assigns[:page] = stub_model(Page).as_new_record #rspec 1
    assigns[:courses] =  [
      stub_model(Course),
      stub_model(Course)
    ]
#    assign(:page, stub_model(Page).as_new_record) #rspec 2
  end

  it "renders new page form" do
    render

    response.should have_tag("form", :action => pages_path, :method => "post") #rspec 1
#    rendered.should have_selector("form", :action => pages_path, :method => "post") #rspec 2
  end
end
