require 'spec_helper'

describe 'grading assignments page' do
    before :each do
    @faculty = FactoryGirl.create(:faculty_frank_user)
    @student_sally = FactoryGirl.create(:student_sally)
    @team = FactoryGirl.create(:team_triumphant, :members => [@student_sally] )
    @course = FactoryGirl.create(:fse)
    @faculty_assignment = FactoryGirl.create(:faculty_assignment,:user => @faculty , :course => @course)
    @course.faculty_assignments << @faculty_assignment
    @assignment = FactoryGirl.create(:assignment, :is_team_deliverable => true)
    @deliverable = FactoryGirl.create(:deliverable, :assignment => @assignment , :team => @team, :course => @course, :creator => @student_sally)   
    @deliverable_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable, :submitter => @student_sally )


    end

    it 'shows me deliverables of my team' do
        login_with_oauth @faculty
        url = "/courses/#{@course.id}/deliverables"
        visit(url)
        save_and_open_page
    end

end

