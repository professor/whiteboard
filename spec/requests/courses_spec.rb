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
      page.should have_selector("table#grading_range > tbody > tr", count: 5)
      page.should have_selector("table#grading_range > tbody > tr:first > td", count: 2)
    end

    it 'should save when numerical values are entered' do
      saved_grading_range = {}
      JSON.parse(@course.grading_range).each_with_index do |(letter, value), index|
        STDERR.puts letter.inspect, value.inspect, index.inspect
        select letter, from: "grading_range_letter_#{index}"
        STDERR.puts "hi madhok"
        fill_in "grading_range_value_#{index}", with: value["minimum"] + 1
        STDERR.puts "...."
        saved_grading_range[letter] = {"minimum" => value["minimum"] + 1}
        STDERR.puts "hi david"
      end
      click_button "Update"
      @course.reload
      @course.get_sorted_grading_range.should == ActiveSupport::JSON.encode(saved_grading_range)
    end
  end
end