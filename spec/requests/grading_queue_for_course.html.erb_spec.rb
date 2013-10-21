require 'spec_helper'

describe "deliverables/grading_queue_for_course" do
    before :each do
        @faculty = FactoryGirl.create(:faculty_frank_user)
        @faculty_not_me = FactoryGirl.create(:faculty_fagan_user)
        @student_sally = FactoryGirl.create(:student_sally)
        @student_sam = FactoryGirl.create(:student_sam)
        @team = FactoryGirl.create(:team_triumphant, :members => [@student_sally] )
        @team_not_mine = FactoryGirl.create(:team_bean_counters, :members => [@student_sam] )
        @course = FactoryGirl.create(:fse)
        @faculty_assignment = FactoryGirl.create(:faculty_assignment,:user => @faculty , :course => @course)
        @course.faculty_assignments << @faculty_assignment
        @assignment = FactoryGirl.create(:assignment, :is_team_deliverable => true, :course => @course)
        
        @deliverable = FactoryGirl.create(:deliverable, :assignment => @assignment , :team => @team, :course => @course, :creator => @student_sally)   
        @deliverable_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable, :submitter => @student_sally )
        @deliverable_not_mine = FactoryGirl.create(:deliverable, :assignment => @assignment , :team => @team_not_mine, :course => @course, :creator => @student_sam)   
        @deliverable_attachment_not_mine = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_not_mine, :submitter => @student_sam )

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

    it "should have checkboxes that provide different filtering conditions" do
        expect(page).to have_content 'Ungraded'
        expect(page).to have_content 'Graded'
        expect(page).to have_content 'Drafted'
        check 'Ungraded'
        check 'Graded'
        check 'Drafted'
    end

    it "Should have the following selected in assignments inlcuding" do
        expect(page).to have_content('selected_assignment')
        expect(page).to have_content(@assignment.name)
    end

    it "should shows submitted deliverables" do
        pending
    end

    it "should not show teams don't belong to me after selecting My Team" do
        pending
#        choose('filter_my_teams')
#        expect(page).not_to have_content("Team Bean Counters")
    end
end
