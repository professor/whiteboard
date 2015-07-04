require 'spec_helper'

describe "Assignments" do
  before do

    visit ('/')
    @faculty_fagan = FactoryGirl.create(:faculty_fagan)
    login_with_oauth @faculty_fagan
    #@course = FactoryGirl.create(:fse)
    @assignment=FactoryGirl.create(:assignment_fse)
    @course = @assignment.course
    @course.faculty << @faculty_fagan

  end
  describe "GET /assignments" do
    it "should load the page with assignment details" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit (course_assignments_path(@course))
      page.should have_content(@assignment.name)
      page.should have_content(@assignment.task_number)
    end

    #it "should load the page with assignment details" do
    #  # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
    #  visit (course_assignments_path(@course))
    #  click_link "Edit"
    #  edit_course_assignment_path(@course,@assignment).should eq(current_path)
    #  page.body.should have_content(@assignment.name)
    #  page.should have_content(@assignment.due_date)
    #end


    it "should load the page with assignment details" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit (course_assignments_path(@course))
      click_link "Delete"
      page.should_not have_content(@assignment.name)
    end




  end
end
