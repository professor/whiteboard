require "spec_helper"

describe "effort reports" do

  before do
    @user = FactoryGirl.create(:student_sam)
    login_with_oauth @user
    visit('/effort_reports')
  end

  context "shows effort reports" do

    it "renders effort reports page" do
      page.should have_content("Effort Reports")
      page.should have_content("Campus View")
      page.should have_content("Course View")
      page.should have_link("Pick a course")

    end
  end
end