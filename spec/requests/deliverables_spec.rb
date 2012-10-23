require "spec_helper"

describe "deliverables" do

  before do
    visit('/')
    @team = FactoryGirl.create(:team_triumphant)
    @user = @team.members[0]
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

    context "submitting" do
      before {
        #file = fixture_file_upload(Rails.root + 'spec/fixtures/files/sample_assignment.txt', 'text/txt')
        assignment = FactoryGirl.create(:assignment)
        Registration.create(user_id: @user.id, course_id: assignment.course.id)
        click_link "New deliverable"
      }

      it "should have all courses in the courses dropdown" do
        page.should have_selector("select#deliverable_course_id > option", count: @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}.count)
      end

      it "should save" do
        fill_in 'Name', with: 'Deliverable1'
        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/files/sample_assignment.txt'
        courses = @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}
        STDERR.puts "User in test:"
        STDERR.puts @user.inspect
        STDERR.puts courses.inspect

        select courses[0].name, from: 'course_id'
        assignment = courses[0].assignments[0]
        option_text = "Task #{assignment.task_number}: #{assignment.title} " + (assignment.team_deliverable ? "(Team deliverable)" : "")
        select option_text, from: 'deliverable_assignment_id'
        click_button 'Create'
      end
      context "submitting feedback" do
      end
    end
  end
end