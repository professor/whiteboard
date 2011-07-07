require 'spec_helper'

describe "courses/new.html.erb" do
  before(:each) do
    login_user(Factory(:faculty_frank))
    course = stub_model(Course).as_new_record
    course.stub(:people).and_return([stub_model(Person)])
    assign(:course, course)
    assign(:course_numbers, [stub_model(CourseNumber)])

  end

  it "renders new page form" do
    render

    response.should have_tag("form", :action => courses_path, :method => "post")
  end

 it 'should have fields' do
   render

    response.should have_tag('form') do |f|
      f.should have_tag("input[name='course[number]']")
      f.should have_tag("select[name='course[semester]']")
      f.should have_tag("input[name='course[year]']")
    end
  end

  it 'should have defaults (ie current year)'

end
