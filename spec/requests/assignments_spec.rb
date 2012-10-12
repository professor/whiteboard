require "spec_helper"

describe "assignments" do
  context "saving new" do
    before {
      @course = FactoryGirl.create(:course)
      visit new_course_assignment_path(@course.id)
      fill_in "Task number", with: 1
      fill_in "Title", with: "New Task"
      fill_in "Weight", with: "10"
      fill_in "Due date", with: DateTime.now + 30
      choose "assignment_team_deliverable_true"
      find(:css, "#assignment_can_submit").set(true)
    }

    it "should save a new assignment" do
      expect {
        click_button "Save Assignment"
      }.to change(Assignment, :count).by(1)
    end

    it "should not save a new assignment" do
      fill_in "Weight", with: 120

      expect {
        click_button "Save Assignment"
      }.to change(Assignment, :count).by(0)
    end
  end
end