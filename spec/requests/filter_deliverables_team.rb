require 'spec_helper'

describe 'grading assignments page' do
    before :each do
        # Create Faculty
        @faculty_frank = FactoryGirl.create(:faculty_frank_user)
        @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)

        # Create Students
        @student_sally = FactoryGirl.create(:student_sally)
        @student_sam = FactoryGirl.create(:student_sam)

        # Create a course
        @course = FactoryGirl.create(:fse)
        @faculty_assignment_1 = FactoryGirl.create(:faculty_assignment,:user => @faculty_frank , :course => @course)
        @faculty_assignment_2 = FactoryGirl.create(:faculty_assignment,:user => @faculty_fagan , :course => @course)
        @course.faculty_assignments << @faculty_assignment_1 
        @course.faculty_assignments << @faculty_assignment_2

        # Create an assignment for the course
        @team_assignment = FactoryGirl.create(:assignment, :name => 'Team Assignment', :is_team_deliverable => true, :course => @course)
        @indi_assignment = FactoryGirl.create(:assignment, :name => 'Individual Assignment', :course => @course)

        # Creating teams
        @team_triumphant = FactoryGirl.create(:team_triumphant, :members => [@student_sally], :primary_faculty => @faculty_frank )
        @team_bean_counters = FactoryGirl.create(:team_bean_counters, :members => [@student_sam], :primary_faculty => @faculty_fagan )

        # Team Deliverables
        @deliverable_1 = FactoryGirl.create(:deliverable, :assignment => @team_assignment , :team => @team_triumphant, :course => @course, :creator => @student_sally)   
        @deliverable_1_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_1, :submitter => @student_sally )
        @deliverable_2 = FactoryGirl.create(:deliverable, :assignment => @team_assignment , :team => @team_bean_counters , :course => @course, :creator => @student_sam)   
        @deliverable_2_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_2, :submitter => @student_sam )

        # Individual Deliverables
        @deliverable_3 = FactoryGirl.create(:deliverable, :assignment => @indi_assignment , :course => @course, :creator => @student_sally)   
        @deliverable_3_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_3, :submitter => @student_sally )
        @deliverable_4 = FactoryGirl.create(:deliverable, :assignment => @indi_assignment , :course => @course, :creator => @student_sam)   
        @deliverable_4_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_4, :submitter => @student_sam )

        login_with_oauth @faculty_frank
    end

    context 'displays deliverables of my teams only' do
        before :each do
            url = "/courses/#{@course.id}/deliverables?teams=my_teams"
            visit(url)
        end

        it ' should have team and individual deliverable links ' do
            page.should have_link('Team Deliverables')
            page.should have_link('Individual Deliverables')
        end

        it 'under team deliverables tab' do
            page.should have_content(@faculty_frank.human_name)
            page.should_not have_content(@faculty_fagan.human_name)
        end

        it ' under individual deliverables tab' do

        end
    end

end

