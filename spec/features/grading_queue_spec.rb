  require 'spec_helper'
  include IntegrationSpecHelper
  include ControllerMacros

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
      before do
        @course = FactoryGirl.create(:mfse_current_semester)
        @faculty_assignment = FactoryGirl.create(:faculty_assignment,:course_id=>@course.id,:user_id=>@faculty_fagan.id)
        @course.faculty_assignments << @faculty_assignment
        #@course.save
        #@faculty_fagan.faculty_assignments<<@faculty_assignment
        #@faculty_assignment = FactoryGirl.create(:faculty_assignment, :user=>@faculty_fagan, :course => @course)
        #@course.faculty_assignments << @faculty_assignment
        #@person_fagan = FactoryGirl.create(:faculty_fagan)
        #@course_assignments = FactoryGirl.create(:course => @course,:faculty =>[@faculty_fagan])
        #@faculty_fagan.teaching_these_courses << @course_assignments
        visit('/')
        click_link "Courses"
        @semester = AcademicCalendar.current_semester()
        @year = Date.today.year
        @deliverable = FactoryGirl.create(:deliverable)
        @assignment=FactoryGirl.create(:assignment_fse)
        @student = FactoryGirl.create(:student_sam)
        @deliverableAttachment=DeliverableAttachment.create(:attachment_file_name=>"Submitted deliverable",:deliverable_id=>@deliverable.id,:submitter_id=>@student.id)
        #@course.faculty.stub(:include?).with(@faculty_fagan).and_return(true)

        @faculty_frank = FactoryGirl.create(:faculty_frank_user)
        @student_jack = FactoryGirl.create(:student_jack_user)
        @student_jill = FactoryGirl.create(:student_jill_user)
        @team_triumphant = FactoryGirl.create(:team_triumphant,:members=>[@student_jack],:primary_faculty=>@faculty_fagan)
        @team_bean_counters = FactoryGirl.create(:team_bean_counters,:members=>[@student_jill],:primary_faculty=>@faculty_frank)

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

      it "should have a link for MSFE" do
        page.should have_link("Metrics for Software Engineers (MfSE)")
      end

      it"should display the grading queue page" do
        visit course_deliverables_path(@course)
      end

      it "should show only those teams that are assigned to the staff member" do
        pending
      end

    end
  end
