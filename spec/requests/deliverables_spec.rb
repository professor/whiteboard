require "spec_helper"

describe "deliverables" do

  before do
    visit('/')
    @team = FactoryGirl.create(:team_triumphant)
    @user = @team.members[0]
    login_with_oauth @user
    click_link "My Deliverables"
  end

  context "Student deliverables" do

    it "renders my deliverables page" do
      page.should have_content("Listing Deliverables")
      page.should have_link("New deliverable")
    end

    it "lets the user create new deliverable"  do
      click_link "New deliverable"
      page.should have_content("New deliverable")
      page.should have_selector("select#deliverable_course_id")
      page.should have_button("Create")
    end

    context "submitting" do
      before {
        @assignment = FactoryGirl.create(:assignment)
        Registration.create(user_id: @user.id, course_id: @assignment.course.id)
      }

      it "should have all courses in the courses dropdown" do
        # Add one for the empty option
        visit new_deliverable_path
        page.should have_selector("select#deliverable_course_id > option", count: @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}.count + 1)
      end

      context "visiting a populated deliverable submission page" do
        before {
          visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
          courses = @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}
        }

        it "should save" do
          attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/files/sample_assignment.txt'
          expect { click_button 'Create' }.to change(Deliverable, :count).by(1)
        end

        it "should not save" do
          expect { click_button 'Create' }.to_not change(Deliverable, :count)

          page.should have_selector("h1", text: "New deliverable")
          page.should have_selector(".ui-state-error")
        end
      end

      it "should not save with blank fields" do
        visit new_deliverable_path
        expect { click_button 'Create' }.to change(Deliverable, :count).by(0)

        page.should have_selector("h1", text: "New deliverable")
        page.should have_selector(".ui-state-error")
      end
    end
  end

  context "Professor deliverables" do
    context "grading team deliverable" do
      before {
        @assignment = FactoryGirl.create(:assignment, team_deliverable: true, course: @team.course)
        Registration.create(user_id: @user.id, course_id: @assignment.course.id)
        visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/files/sample_assignment.txt'
        click_button "Create"
        @professor = FactoryGirl.create(:faculty_frank_user)
        @assignment.course.faculty_assignments_override = [@professor.human_name]
        @assignment.course.update_faculty
        login_with_oauth @professor
        visit deliverable_feedback_path(Deliverable.last)
        page.should have_selector('h1', text: "Grade Team Deliverable")
      }

      it "should provide feedback and a grade to each student in the team" do
        fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
        click_button "Submit"
        Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
        Deliverable.last.status.should == 'Graded'
      end

      it "should save as draft" do
        fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
        click_button "Save as draft"
        Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
        Deliverable.last.status.should == 'Draft'
      end
    end

    context "grading individual deliverables" do
      before {
        @assignment = FactoryGirl.create(:assignment, team_deliverable: false)
        Registration.create(user_id: @user.id, course_id: @assignment.course.id)
        visit new_deliverable_path(course_id: @assignment.course.id, assignment_id: @assignment.id)
        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/files/sample_assignment.txt'
        click_button "Create"
        @professor = FactoryGirl.create(:faculty_frank_user)
        @assignment.course.faculty_assignments_override = [@professor.human_name]
        @assignment.course.update_faculty
        login_with_oauth @professor
      }

      it "should provide feedback and a grade to the student" do
        visit deliverable_feedback_path(Deliverable.last)
        page.should have_selector('h1', text: "Grade Individual Deliverable")
        fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
        click_button "Submit"
        Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
        Deliverable.last.status.should == 'Graded'
      end

      it "should save as draft" do
        visit deliverable_feedback_path(Deliverable.last)
        page.should have_selector('h1', text: "Grade Individual Deliverable")
        fill_in "deliverable_deliverable_grades_attributes_0_grade", with: 10
        click_button "Save as draft"
        Deliverable.last.deliverable_grades.first.number_grade.should == 10.0
        Deliverable.last.status.should == 'Draft'
      end

      context "unallowed access" do
        before {
          @dwight = FactoryGirl.create(:faculty_dwight_user)
          login_with_oauth @dwight
        }

        it "should not allow unassigned faculty to grade" do
          visit deliverable_feedback_path(Deliverable.last)
          page.should have_selector('.ui-state-error')
        end
      end
    end
  end
end