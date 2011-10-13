require "spec_helper"

describe "effort logs" do

  before do
   visit('/')
#   @effort_log = Factory(:effort_log)
#   @user = @effort_log.person
   @user = Factory(:student_sam)
   login_with_oauth @user
   click_link "Effort Logs"
  end

  context "shows effort logs" do

    it "renders effort logs page" do

      page.should have_content("Listing Effort Logs")
      page.should have_content("Week number")
      page.should have_content("Starting on")
      page.should have_content("Effort")
      page.should have_link("New effort log") || have_link("edit")
      page.should have_link("Back")
      if has_link?("Show")
         click_link "Show"
         page.should have_content("Show Effort Log")
      end
    end
  end

  #context "new effort log" do
  #
  #  it "renders new effort log page" do
  #    if has_link?("New effort log")
  #       click_link "New effort log"
  #       page.should have_content("New Effort Log")
  #       page.should have_button("Create")
  #       page.should have_link("Back")
  #    end
  #  end
  #  it "creates the effort log" do
  #    if has_link?("New effort log")
  #       click_link "New effort log"
  #      click_button "Create"
  #      page.should have_content("EffortLog was successfully created.")
  #    end
  #  end
  #end



  context "edit effort log" do
    it "renders editing effort log page" do

      if has_link?("Edit")
        click_link "Edit"
        page.should have_content("Editing Effort Log")
        page.should have_button("Update")
        page.should have_link("Add another line")
        page.should have_link("Show")
        page.should have_link("Back")
      end

    end

    it "updates the effort log and links to previous page" do

      if has_link?("Edit")
        click_link "Edit"
        page.should have_link("Update")
      end

    end
  end

end