require 'spec_helper'

describe "pages/new.html.erb" do
  before(:each) do
    login(Factory(:faculty_frank))
    assign(:page, stub_model(Page).as_new_record)
    assign(:courses, [
      stub_model(Course),
      stub_model(Course)
    ])
  end

  it "renders new page form" do
    render

    rendered.should have_selector("form", :action => pages_path, :method => "post")
  end
end
