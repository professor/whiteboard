require "spec_helper"

describe "effort reports" do

  before do
    visit('/')
    @user = Factory(:student_sam)
    login_with_oauth @user
    click_link "Effort Reports"
  end

  context "shows effort reports" do

    it "renders effort reports page" do
      page.should have_content("Effort Reports")
      page.should have_content("Campus View")
      page.should have_content("Course View")
      page.should have_link("Pick a course")

    end

    it "lets the user pick a course" do

      click_link "Pick a course"
      page.should have_content("Courses")
      page.should have_link("See all courses")
      page.should have_link("course selections")
      page.should have_selector("input#filterBoxOne")
      click_link "See all courses"
      page.should have_content("All Courses")
      page.should have_link("See current semester")
      click_link "See current semester"
      page.should have_content("Courses")
      page.should have_link("See all courses")


    end
  end
end