require "spec_helper"

describe "assignments" do
  context "saving" do
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

    context "new" do
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

  context "edit" do
    before {
      @assignment = FactoryGirl.create(:assignment)
      visit edit_assignment_path(@assignment.id)
    }

    it "should change title field" do
      fill_in "Title", with: "My Test Assignment"
      click_button "Save Assignment"
      @assignment.reload.title.should == "My Test Assignment"
    end

    it "should not change weight" do
      fill_in "Weight", with: 120
      click_button "Save Assignment"
      @assignment.reload.weight.should_not == 120
    end
  end

  context "delete" do
    before {
      @assignment = FactoryGirl.create(:assignment)
    }

    it "should delete an assignment" do
      visit course_assignments_path(@assignment[:course_id])
      expect {
        click_link "Delete"
      }.to change(Assignment, :count).by(-1)
    end
  end
end