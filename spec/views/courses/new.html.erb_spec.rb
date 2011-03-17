require 'spec_helper'

describe "courses/new.html.erb" do
  before(:each) do
    UserSession.create(Factory(:faculty_frank))
    assigns[:course] = stub_model(Course).as_new_record
    assigns[:course_numbers] = [stub_model(CourseNumber)]

  end

  it "renders new page form" do
    render

    response.should have_tag("form", :action => courses_path, :method => "post")
  end

 it 'should have fields' do
   render

    response.should have_tag('form') do |f|
      f.should have_tag("input[name='course[name]']")
      f.should have_tag("input[name='course[number]']")
    end
  end

  it 'should have defaults (ie current year)'

end
