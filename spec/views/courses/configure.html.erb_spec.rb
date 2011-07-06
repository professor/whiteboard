require 'spec_helper'

describe "courses/configure.html.erb" do
  before(:each) do
    login_user(Factory(:faculty_frank))
    @course = assigns[:course] = stub_model(Course,
        :name => "something",
        :semester => "Fall",
        :year => "2011",
        :mini => "Both",
      :new_record? => false
    )
  end

  it "renders the configure course form" do
    render

    response.should have_tag("form", :action => course_path(@course), :method => "post")
  end
end
