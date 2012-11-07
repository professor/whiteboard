require "spec_helper"

describe "assignments" do
  context "saving" do
    before {
      @course = FactoryGirl.create(:course)
      @user = FactoryGirl.create(:faculty_frank)
      login_with_oauth @user
      visit new_course_assignment_path(@course.id)
      fill_in "Task number", with: 1
      fill_in "Title", with: "New Task"
      fill_in "assignment_weight", with: "10"
      fill_in "Due date", with: DateTime.now + 30
      choose('assignment_can_submit_true')
      choose('assignment_team_deliverable_true')
    }

    context "new" do
      it "should save a new assignment" do
        expect {
          click_button "Save Assignment"
        }.to change(Assignment, :count).by(1)
      end

      it "should not save a new assignment" do
        @course.update_attributes(grading_criteria: "Percentage")

        fill_in "assignment_weight", with: 120

        expect {
          click_button "Save Assignment"
        }.to change(Assignment, :count).by(0)
      end

      it "should create a placeholder deliverable when creating an unsubmittable assignment" do
        expect {
          choose('assignment_can_submit_false')
          click_button "Save Assignment"
        }.to change(Deliverable, :count).by(1)
      end
    end
  end

  context "edit" do
    before {
      @assignment = FactoryGirl.create(:assignment)
      @user = FactoryGirl.create(:faculty_frank)
      login_with_oauth @user
      visit edit_assignment_path(@assignment.id)
    }

    it "should change title field" do
      fill_in "Title", with: "My Test Assignment"
      click_button "Save Assignment"
      @assignment.reload.title.should == "My Test Assignment"
    end

    it "should not change weight" do
      @assignment.course.update_attributes(grading_criteria: "Percentage")
      fill_in "assignment_weight", with: 120
      click_button "Save Assignment"
      @assignment.reload.weight.should_not == 120
    end
  end

  context "delete" do
    before {
      @assignment = FactoryGirl.create(:assignment)
      @user = FactoryGirl.create(:faculty_frank)
      login_with_oauth @user
    }

    it "should delete an assignment" do
      visit course_assignments_path(@assignment[:course_id])
      expect {
        click_link "Delete"
      }.to change(Assignment, :count).by(-1)
    end
  end
end