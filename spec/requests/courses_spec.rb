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
      page.should have_selector("table#grading_range > tbody > tr", count: 13)
      page.should have_selector("table#grading_range > tbody > tr:first > td", count: 3)
    end

    it 'should save when numerical values are entered' do
      @course.grading_ranges.each_with_index do |grading_range, index|
        fill_in "course_grading_ranges_attributes_#{index}_minimum", with: grading_range['minimum'] + 1
      end

      click_button "Update"

      @course.reload

      GradingRange.possible_grades.each_with_index do |(grade, value), index|
        @course.grading_ranges[index][:minimum].should == value + 1
      end
    end
  end
end