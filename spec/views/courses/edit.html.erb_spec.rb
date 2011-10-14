require 'spec_helper'

describe "courses/edit.html.erb" do
  before(:each) do

    current_user = Factory.build(:faculty_frank)
    @course = assign(:course, stub_model(Course,
        :name => "something",
      :new_record? => false
    ))
    @course.stub(:faculty).and_return([stub_model(Person)])
    assign(:course_numbers, [stub_model(CourseNumber)])
  end

  it "renders the edit course form" do
    render

    rendered.should have_selector("form", :action => course_path(@course), :method => "post")
  end
end
