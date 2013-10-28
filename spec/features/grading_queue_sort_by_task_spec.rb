require 'spec_helper'
include IntegrationSpecHelper

describe 'Grading queue' do

  it 'As a faculty, I can sort all assignments or deliverables by task numbers' do
      @course=FactoryGirl.create(:fse)
      @faculty_fagan = FactoryGirl.create(:faculty_fagan_user)
      login_with_oauth @faculty_fagan
      @faculty_assignment = FactoryGirl.create(:faculty_assignment,:course_id=>@course.id,:user_id=>@faculty_fagan.id)
      @course.faculty_assignments<<@faculty_assignment

      @assignment1=FactoryGirl.create(:assignment_fse_individual)
      @assignment2=FactoryGirl.create(:assignment_fse_individual2)
      @assignment3=FactoryGirl.create(:assignment_fse_individual3)
      @deliverable1=FactoryGirl.create(:individual_deliverable1, course_id: @course.id)
  #    deliverable2=FactoryGirl.create(:individual_deliverable2)
  #    deliverable3=FactoryGirl.create(:individual_deliverable3)
  #    deliverable4=FactoryGirl.create(:individual_deliverable4)
      @deliverable1.stub(:get_grade_status).and_return(:graded)
  #    deliverable2.stub(:get_grade_status).and_return(:graded)
  #    deliverable3.stub(:get_grade_status).and_return(:graded)
  #    deliverable4.stub(:get_grade_status).and_return(:graded)
#      @student = mock_model("User", human_name: "Bob Bobberson", id: 99999)
#      @deliverableAttachment1=DeliverableAttachment.create(:attachment_file_name=>"Submitted deliverable 1",:deliverable_id=>@deliverable1.id,:submitter_id=>@student.id)

#      visit course_deliverables_path(@course)
#      save_and_open_page

    end
end
