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
end