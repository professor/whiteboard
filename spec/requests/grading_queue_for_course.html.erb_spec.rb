require 'spec_helper'

describe "deliverables/grading_queue_for_course" do
    before :each do
        @faculty = FactoryGirl.create(:faculty_frank_user)
#        @faculty_not_me = FactoryGirl.create(:faculty_fagan_user)
        @course = FactoryGirl.create(:fse)
        @course.faculty << @faculty
#        @student_sally = FactoryGirl.create(:student_sally)
#        @student_sam = FactoryGirl.create(:student_sam)
#        @team_mine = FactoryGirl.create(:team_triumphant, :members => [@student_sally], :course => @course, :primary_faculty => @faculty )
#        @team_not_mine = FactoryGirl.create(:team_bean_counters, :members => [@student_sam], :course => @course, :primary_faculty => @faculty_not_me)

#        @faculty_assignment = FactoryGirl.create(:faculty_assignment,:user => @faculty , :course => @course)
#        @course.faculty_assignments << @faculty_assignment
#        @assignment = FactoryGirl.create(:assignment, :is_team_deliverable => true, :course => @course, :name => "Assignment 1")

#        Registration.create(user_id: @student_sally, course_id: @course.id)
#        Registration.create(user_id: @student_sam, course_id: @course.id)

#        login_with_oauth @student_sally
#        visit new_deliverable_path(course_id: @course.id, assignment_id: @assignment.id)
#        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/sample_assignment.txt'
#        click_button "Create"
#        visit "/logout"

#        login_with_oauth @student_sam
#        visit new_deliverable_path(course_id: @course.id, assignment_id: @assignment.id)
#        attach_file 'deliverable_attachment_attachment', Rails.root + 'spec/fixtures/sample_assignment.txt'
#        click_button "Create"
#        visit "/logout"

        login_with_oauth @faculty
        visit("/courses/#{@course.id}/deliverables")

    end

    before :each do
        visit("/courses/#{@course.id}/deliverables")
    end

    it "should have a radio button group which has two items: My Team and All" do
        expect(page).to have_content("My Teams")
        expect(page).to have_content("All Teams")
    end

    it "should have a column that indicates who is responsible for grading this deliverable" do
        expect(page).to have_content("Advisor")    
    end

    it "should shows submitted deliverables" do
        pending
#        expect(page).to have_content("Assignment 1")
    end

    it "should not show teams don't belong to me after selecting My Team" do
        pending
#        choose('filter_my_teams')
#        expect(page).not_to have_content("Team Bean Counters")
    end
end
