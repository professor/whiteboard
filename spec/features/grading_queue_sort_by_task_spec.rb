require 'spec_helper'
include IntegrationSpecHelper

describe 'Grading queue' do

  it 'As a faculty, I can sort all assignments or deliverables by task numbers', js:true do

    @course=FactoryGirl.create(:fse)
    @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)
    login_with_oauth @faculty_fagan
    @faculty_assignment = FactoryGirl.create(:faculty_assignment, :course_id => @course.id, :user_id => @faculty_fagan.id)
    @course.faculty_assignments<<@faculty_assignment
    @student = FactoryGirl.create(:student_sally_user)

    @assignment1=FactoryGirl.create(:assignment_fse_individual)
    @assignment2=FactoryGirl.create(:assignment_fse_individual2)
    @assignment3=FactoryGirl.create(:assignment_fse_individual3)
    @deliverable1=FactoryGirl.create(:individual_deliverable1, course_id: @course.id, creator_id: @student.id)
    @deliverable2=FactoryGirl.create(:individual_deliverable2, course_id: @course.id, creator_id: @student.id)
    @deliverable3=FactoryGirl.create(:individual_deliverable3, course_id: @course.id, creator_id: @student.id)
    @deliverable4=FactoryGirl.create(:individual_deliverable4, course_id: @course.id, creator_id: @student.id)

    visit course_deliverables_path(@course)
    #save_and_open_page
    #click task_number
    expect(page.find('th',text:'Task number').text).to eq('Task number')
    find('th', text: 'Task number').click
    #save_and_open_page

  end
end
