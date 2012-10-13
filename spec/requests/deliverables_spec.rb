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

=begin
    context "submitting" do
      before { click_link "New deliverable" }
      it "should have all courses in the courses dropdown" do
        page.should have_selector("select#deliverable_course_id > option", count: @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}.count)
      end

      it "should save" do
        fill_in 'Name', with: 'Deliverable1'
        find(:css, "#deliverable_attachment_attachment").set('my_image.png')
        courses = @user.registered_for_these_courses_during_current_semester.delete_if {|course| course.assignments.empty?}
        select courses[0].name, from: 'deliverable_course_id'
        select courses[0].assignments[0].title, from: 'deliverable_assignment_id'
        click_button 'Create'
      end
    end
=end
  end
end