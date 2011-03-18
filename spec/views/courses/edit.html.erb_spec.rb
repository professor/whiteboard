require 'spec_helper'

describe "courses/edit.html.erb" do
  before(:each) do

    UserSession.create(Factory(:faculty_frank))
    @course = assigns[:course] = stub_model(Course,
        :name => "something",
      :new_record? => false
    )
    @course.stub(:people).and_return([stub_model(Person)])
    assigns[:course_numbers] = [stub_model(CourseNumber)]
  end

  it "renders the edit course form" do
    render

    response.should have_tag("form", :action => course_path(@course), :method => "post")
  end
end
