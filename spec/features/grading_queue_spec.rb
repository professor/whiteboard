require 'spec_helper'
include IntegrationSpecHelper
include ControllerMacros

describe "Login Page" do

  before do
    visit ('/')
    @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)
    login_with_oauth @faculty_fagan
  end

  context "user should be able to login" do
    it "should have logout on the page" do
      page.should have_link("Logout")
    end

    it "should have courses on the page" do
      page.should have_link("Courses")
    end
  end

  context "On the courses page" do
    before(:each) do
      visit('/')
      click_link "Courses"
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      @deliverable = FactoryGirl.create(:deliverable)
      @assignment=FactoryGirl.create(:assignment_fse)
      @course = @assignment.course
      @student = FactoryGirl.create(:student_sam)
      @faculty_assignment = FactoryGirl.create(:faculty_assignment)
      @deliverableAttachment=DeliverableAttachment.create(:attachment_file_name=>"Submitted deliverable",:deliverable_id=>@deliverable.id,:submitter_id=>@student.id)
      @course.faculty.stub(:include?).with(@faculty_fagan).and_return(true)
    end

    it "shows my courses on page faculty" do
      page.should have_content("My courses")
    end

    it "shows all courses on page for faculty" do
      page.should have_content("All Courses")
    end

    it "defaults to a listing of all courses in the semester" do
      page.should have_selector("#courses_for_a_semester")
    end
  end
end


