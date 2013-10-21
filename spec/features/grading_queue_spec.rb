require 'spec_helper'
include IntegrationSpecHelper

describe "Login Page" do

  before do
    visit ('/')
    @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)
    login_with_oauth @faculty_fagan
  end

  context "/" do
    it "should have logout on the page" do
      page.should have_link("Logout #{@faculty_fagan.first_name}")
    end

    it "should have courses on the page" do
      page.should have_link("Courses")
    end
  end

  context "On the courses page" do
    before(:each) do
      @course = FactoryGirl.create(:mfse)
      @faculty_assignment = FactoryGirl.create(:faculty_assignment, :user=>@faculty_fagan, :course => @course)
      @course.faculty_assignments << @faculty_assignment
      @course_assignments = FactoryGirl.create(:registration, :user=>@faculty_fagan, :course=>@course)
      @faculty_fagan.registrations << @course_assignments
      visit('/')
      click_link "Courses"
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      @deliverable = FactoryGirl.create(:deliverable)
      @assignment=FactoryGirl.create(:assignment_fse)
      @student = FactoryGirl.create(:student_sam)
      @deliverableAttachment=DeliverableAttachment.create(:attachment_file_name=>"Submitted deliverable",:deliverable_id=>@deliverable.id,:submitter_id=>@student.id)
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

    it "should contain a link to Metrics of Software Engineering" do
      page.should have_content("#{@course.name} (#{@course.short_name})")
    end

    it"should display the page" do
      save_and_open_page
    end
  end
end

