require 'spec_helper'
include IntegrationSpecHelper

describe 'Grading queue', :js => true, :skip_on_build_machine => true do

  before :each do
#creating a faculty
    @faculty_fagan=FactoryGirl.create(:faculty_fagan_user)
#creating two students
    @student_sally= FactoryGirl.create(:student_sally_user)
    @student_sam= FactoryGirl.create(:student_sam_user)

#creating two teams
    @team_triumphant=FactoryGirl.create(:team_triumphant, :members => [@student_sally], :primary_faculty => @faculty_fagan)
    @team_bean_counters=FactoryGirl.create(:team_bean_counters, :members => [@student_sam], :primary_faculty => @faculty_fagan)

#creating a course and assigning a faculty to it.
    @course = FactoryGirl.create(:fse_current_semester)
    @faculty_assignment = FactoryGirl.create(:faculty_assignment, :user => @faculty_fagan, :course => @course)
    @course.faculty_assignments<<@faculty_assignment

#Individual Ungraded Assignment by student_sally
    @individual_assignment_ungraded = FactoryGirl.create(:assignment_fse2, :name => 'Individual Assignment 1', :task_number => 1, :course => @course)

    @deliverable2 = FactoryGirl.create(:individual_deliverable2, :assignment => @individual_assignment_ungraded, :course => @course, :creator => @student_sally)
    @deliverable_attachment1 = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable2, :submitter => @student_sally)

#Team Ungraded Assignment by Team Triumphant
    @team_assignment_ungraded= FactoryGirl.create(:assignment_team, :name => 'Team Assignment 1', :task_number => 3, :course => @course)

    @deliverable3 = FactoryGirl.create(:team_deliverable, :assignment => @team_assignment_ungraded, :course => @course, :team => @team_triumphant, :creator => @student_sally)
    @deliverable_attachment3 = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable3, :submitter => @student_sally)


#logging in the faculty
    login_with_oauth @faculty_fagan
  end

  it 'As a faculty, when I click a delivarable, a new accordion will show up' do
    pending("Accordian is not fully implemented")
    visit course_deliverables_path(@course)

    #before I click the deliverable, no dropdown shows up.
    page.has_css?('#dropdown', :visible => false).should be_true
    find(:xpath, "//td", :text => "Team Assignment 1").click
    accordion=find('#dropdown')

    #after I click a deliverable, a dropdown shows up.
    page.has_css?('#dropdown', :visible => true).should be_true
    page.should have_content('Attachment Version History')
    #save_and_open_page

    #click a deliverable again, the dropdown disapears
    find(:xpath, "//td", :text => "Team Assignment 1").click
    page.has_css?('#dropdown', :visible => false).should be_true

  end


  it 'Within the accordion, input some values' do
    pending("Accordian is not fully implemented")
    visit course_deliverables_path(@course)
    find(:xpath, "//td", :text => "Team Assignment 1").click
    page.fill_in 'deliverable_feedback_comment', :with => 'Very good document. But still some grammar mistakes.'
    page.fill_in 'team_grade', :with => '19'
    page.fill_in 'grade__for_student', :with => '19'
    page.fill_in 'deliverable_private_note', :with => 'this team did a very good job'
    save_and_open_page
    #click button to submit
    #click_button('Save and Email')
  end


end
