require "spec_helper"

describe "courses" do

  context "current courses" do
    before do
      visit('/')
      @user = FactoryGirl.create(:student_sam)
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      login_with_oauth @user
      click_link "#{@semester} #{@year}" " Courses"
    end

    it "renders current courses page" do
      page.should have_content("#{@semester} #{@year}" " Courses")
      page.should have_selector("input#filterBoxOne")
      page.should have_link("course selections")
    end

    it "defaults to a listing of all courses in the semester" do
        page.should have_selector("#courses_for_a_semester")
    end

    it "toggles to a visual representation of courses" do
      click_link "Show courses by minis"
      page.should have_selector("#courses_by_length")
    end

    context "all courses" do
      it 'renders all courses' do
        click_link "Courses"
        page.should have_content("All Courses")
        page.should have_link("See current semester")
      end
    end
  end

  context "configuring grading range" do
    before do
      visit('/')
      @user = FactoryGirl.create(:faculty_frank_user)
      @semester = AcademicCalendar.current_semester()
      @year = Date.today.year
      login_with_oauth @user
      click_link "#{@semester} #{@year}" " Courses"
      @course = FactoryGirl.create(:course)
      visit configure_course_path(@course)
    end

    it "should reach the right course configuration page" do
      page.should have_content("Configure your course, #{@course.name}")
    end

    it "should have grading range table" do
      page.should have_selector("table#grading_range > tbody > tr", count: GradingRange.possible_grades.count)
      page.should have_selector("table#grading_range > tbody > tr:first > td", count: 2)
    end

    it 'should save when numerical values are entered' do
      @course.grading_ranges.each_with_index do |grading_range, index|
        fill_in "course_grading_ranges_attributes_#{index}_minimum", with: grading_range['minimum'] + 1
      end

      click_button "Update Grading Criteria"
      @course.reload
      GradingRange.possible_grades.each_with_index do |(grade, value), index|
        @course.grading_ranges[index][:minimum].should == value + 1
      end
    end

    it 'should not save when grades are not descending' do
      fill_in "course_grading_ranges_attributes_0_minimum", with: 90
      fill_in "course_grading_ranges_attributes_1_minimum", with: 95
      click_button "Update Grading Criteria"

      page.should have_selector("#error_explanation", content: "Number values must be descending by descending grades")
    end
  end

  context "gradebook" do
    before {
      @ppm_course = FactoryGirl.create(:ppm_current_semester)
    }

    it "should be able to grade a unsubmitted assignment" do
      login_with_oauth @ppm_course.faculty.first
      visit course_gradebook_path(@ppm_course)
      page.should have_selector("h1", text: @ppm_course.name)

      expect {
        click_link "Not Submitted"
      }.to change(Deliverable, :count).by(1)
    end

    context "unallowed access" do
      before {
        @dwight = FactoryGirl.create(:faculty_dwight_user)
        login_with_oauth @dwight
      }

      it "should not allow access to assignments related pages" do
        visit course_gradebook_path(@ppm_course)
        page.should have_selector(".ui-icon-alert")
        page.should_not have_selector("h1", text: @ppm_course.name)
      end
    end
  end
end