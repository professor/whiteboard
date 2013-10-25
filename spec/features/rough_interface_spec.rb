require 'spec_helper'
include IntegrationSpecHelper
include ControllerMacros


describe 'Grading Queue' do
before do
@faculty =  FactoryGirl.create(:faculty_fagan_user)	
login_with_oauth @faculty
@course = FactoryGirl.create(:fse_current_semester)
@faculty_assignment = FactoryGirl.create(:faculty_assignment,:course_id=>@course.id,:user_id=>@faculty.id)
@course.faculty_assignments<<@faculty_assignment 
@student1 = FactoryGirl.create(:student_sally_user)
@student2 = FactoryGirl.create(:student_sam_user)
@student3 = FactoryGirl.create(:student_setech_user)
@student4 = FactoryGirl.create(:student_phd_user)
visit('/courses/'+@course.id.to_s+'/deliverables')
end

it "should have content Submitted Assignments" do 

   expect(page).to have_content 'Submitted Assignments'

	end

it "should have checkboxes for filtering" do

    page.has_selector?(:show_individual)
    page.has_selector?(:show_teams)
    page.has_selector?(:show_graded)

	end	
it "should show only ungraded assignments" do
    
    @assignment1=FactoryGirl.create(:assignment_fse_individual)
    @assignment2=FactoryGirl.create(:assignment_fse_individual2)
    @assignment3=FactoryGirl.create(:assignment_fse_individual3)
   

    @deliverable1=FactoryGirl.create(:individual_deliverable1, course_id: @course.id, creator_id: @student1.id)
    @deliverable2=FactoryGirl.create(:individual_deliverable2, course_id: @course.id, creator_id: @student2.id)
    @deliverable3=FactoryGirl.create(:individual_deliverable3, course_id: @course.id, creator_id: @student3.id)
    @deliverable4=FactoryGirl.create(:individual_deliverable4, course_id: @course.id, creator_id: @student4.id)
    
    @deliverable1.stub(:get_grade_status).and_return(:graded)
    @deliverable2.stub(:get_grade_status).and_return(:graded)
    @deliverable3.stub(:get_grade_status).and_return(:graded)
    @deliverable4.stub(:get_grade_status).and_return(:graded)

     # @assignment1=FactoryGirl.create(:individual_deliverable1)
     # @assignment2=FactoryGirl.create(:individual_deliverable2)
     # @assignment3=FactoryGirl.create(:individual_deliverable3)
     # @assignment4=FactoryGirl.create(:individual_deliverable4)
    
    # page.has_no_checked_field?(:show_graded)
    # expect(page).to have_content 'Give Grade'
	end


it "should show display the page" do
  
  	save_and_open_page  
  
 	end
end