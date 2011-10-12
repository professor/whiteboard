require "spec_helper"

describe "courses" do

   before do
   visit('/')
   @user = Factory(:student_sam)
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
      page.should have_link("See all courses")
      click_link  "See all courses"
      page.should have_content("All Courses")
      page.should have_link("See current semester")

    end
  end

end