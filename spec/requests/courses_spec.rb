require "spec_helper"

describe "courses" do

   before do
   visit('/')
   @user = FactoryGirl.create(:student_sam)
   @semester = AcademicCalendar.current_semester()
   @year = Date.today.year
   login_with_oauth @user
   click_link "#{@semester} #{@year}" " Courses"
  end

  context "current courses" do

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

  end

  context "all courses" do
    it 'renders all courses' do
      click_link "Courses"
      page.should have_content("All Courses")
      page.should have_link("See current semester")
   end

  end

end