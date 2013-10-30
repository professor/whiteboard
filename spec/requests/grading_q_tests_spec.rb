require 'spec_helper'

describe "Grading Queue" do
  describe "Testing the framework" do
  
  before { 
  @faculty_1 = FactoryGirl.create(:faculty_frank_user)
  
  @student_1 = FactoryGirl.create(:student_sally_user)
  
  @team_1 = FactoryGirl.create(:team_bean_counters, :members => [@student_1], :primary_faculty_id => @faculty_1)
  
  @course_1 = FactoryGirl.create(:fse)
  
  @faculty_assignment_1 = FactoryGirl.create(:faculty_assignment, :user => @faculty_1, :course => @course_1)

  @course_1.faculty_assignments << @faculty_assignment_1
  
  @assignment_1 = FactoryGirl.create(:assignment, :is_team_deliverable => true, :course => @course_1)
  
  @deliverable_1 = FactoryGirl.create(:deliverable, :assignment => @assignment_1, :course => @course_1, :team => @team_1, :creator => @student_1)
  
  @deliverable_attachment_1 = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_1, :submitter => @student_1)  
  
  
  login_with_oauth @faculty_1
  visit "courses/#{@course_1.id}/deliverables"}


    it "Should have a radio button" do
    
    page.should have_css("#filter_all_teams")
    page.should have_css("#filter_my_teams")
     
	save_and_open_page
    end
    
    it "Should have a Content" do

    page.should have_content("My Teams")
    page.should have_content("All Teams")
#    page.should have_css('#tab-1', :visible => true)
#    page.should have_css('#tab-1', :focus => true)
    page.should have_css('#tab-2', :focus => false)
    end
  end
end
