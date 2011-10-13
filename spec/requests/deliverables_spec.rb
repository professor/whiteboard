require "spec_helper"

describe "deliverables" do

  before do
   visit('/')
   @user = Factory(:student_sam)
   login_with_oauth @user
   click_link "My Deliverables"
  end

  context "My deliverables" do

    it "renders my deliverables page" do
      page.should have_content("Listing Deliverables")
      page.should have_link("New deliverable")
    end

    it "lets the user create new deliverable"  do
      click_link "New deliverable"
      page.should have_content("New deliverable")
      page.should have_selector("input#deliverable_name")
      page.should have_selector("select#deliverable_course_id")
      page.should have_button("Create")
    end

  end
end