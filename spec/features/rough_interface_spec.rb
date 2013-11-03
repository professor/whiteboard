require 'spec_helper'
include IntegrationSpecHelper
include ControllerMacros


describe 'Grading Queue' do

before :each do
#creating a faculty
@faculty_fagan=FactoryGirl.create(:faculty_fagan_user)
#creating two students
@student_sally= FactoryGirl.create(:student_sally_user)
@student_sam= FactoryGirl.create(:student_sam_user)

#creating a teams
@team_triumphant=FactoryGirl.create(:team_triumphant,:members=>[@student_sally],:primary_faculty=>@faculty_fagan)
@team_bean_counters=FactoryGirl.create(:team_bean_counters,:members=>[@student_sam],:primary_faculty=>@faculty_fagan)

#creating a course and assigning a faculty to it.
@course = FactoryGirl.create(:fse_current_semester)
@faculty_assignment = FactoryGirl.create(:faculty_assignment,:user=>@faculty_fagan, :course=>@course)
@course.faculty_assignments<<@faculty_assignment

#Individual Ungraded Assignment by student_sally
@individual_assignment_ungraded = FactoryGirl.create(:assignment_fse2,:name=>'Individual Assignment 1', :course=>@course)

@deliverable2 = FactoryGirl.create(:individual_deliverable2,:assignment=>@individual_assignment_ungraded,:course=>@course,:creator=>@student_sally)
@deliverable_attachment1 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable2,:submitter=>@student_sally)


#Individual Graded Assignment by student_sam
@individual_assignment_graded =FactoryGirl.create(:assignment_fse,:name=>'Individual Assignment 2', :course=>@course)

@deliverable1 = FactoryGirl.create(:individual_deliverable1,:assignment=>@individual_assignment_graded,:course=>@course,:creator=>@student_sam)
@deliverable_attachment2 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable1,:submitter=>@student_sam)

@grade1 = FactoryGirl.create(:grade1,:course=>@course,:student=>@student_sam,:assignment=>@individual_assignment_graded)

#Team Ungraded Assignment by Team Triumphant
@team_assignment_ungraded= FactoryGirl.create(:assignment_team, :name=>'Team Assignment 1', :course=>@course)

@deliverable3 = FactoryGirl.create(:team_deliverable, :assignment=>@team_assignment_ungraded,:course=>@course,:team=>@team_triumphant,:creator=>@student_sally)
@deliverable_attachment3 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable3,:submitter=>@student_sally)

#Team Graded Assignment....
@team_assignment_graded= FactoryGirl.create(:assignment_team, :name=>'Team Assignment 1', :course=>@course)

@deliverable4 = FactoryGirl.create(:team_deliverable, :assignment=>@team_assignment_graded,:course=>@course,:team=>@team_bean_counters,:creator=>@student_sam)
@deliverable_attachment3 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable4,:submitter=>@student_sam)

@grade2 = FactoryGirl.create(:grade1,:course=>@course,:student=>@student_sam,:assignment=>@team_assignment_graded)

#logging in the faculty
login_with_oauth @faculty_fagan
end

context "display the grading queue" do
before :each do
visit("/courses/"+@course.id.to_s+"/deliverables")
end


it "should have content Submitted Assignments" do

   expect(page).to have_content 'Submitted Assignments'

  end

it "should have checkboxes for filtering" do

    page.has_selector?(:show_individual)
    page.has_selector?(:show_teams)
    page.has_selector?(:show_graded)

  end


it "should display only ungraded assignments by default" do

page.has_no_unchecked_field?(:show_graded)
page.has_link?"Give Grade"
   
  end

it "should display graded along with ungraded in the grading queue" do

 page.check('Show Graded')
 page.has_link?"Review Grade"
  end

# it "should not display teams when show team checkbox is unchecked" do

# page.uncheck('Show Team')
# page.should_not have_content 'Team Triumphant'
# page.should not_have_content 'Team Bean Counters'
# end
 
# it "should not display individuals when show individual checkbox is unchecked" do

# page.uncheck('Show Individual')
# page.should_not have_content 'Student Sally'
# page.should not_have_content 'Student Sam'
# end

# it "should show display the page" do
  
#         save_and_open_page
  
#          end


  end
 end