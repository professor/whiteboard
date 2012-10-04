require "spec_helper"

describe "phone book" do

  before do
   visit('/')
   @user = FactoryGirl.create(:student_sam)
   login_with_oauth @user
   click_link "People"
  end

  context "shows phone book" do

    it "renders phone book page" do
      page.should have_content("Phone book")
      page.should have_selector("input#filterBoxOne")
      page.should have_link("See conference rooms")
      page.should have_link("See photo book")

    end

    it "renders photo book" do
      page.should have_link("See photo book")
      click_link "See photo book"
      page.should have_content("Photo Book")
      page.should have_link("See people")
      click_link "See people"
      page.should have_content("Phone book")
    end

    it "lets the admin create a new person" do
      @user = FactoryGirl.create(:admin_andy)
      login_with_oauth @user
      click_link "People"
    end

  end

end