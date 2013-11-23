require 'spec_helper'
include IntegrationSpecHelper

describe 'Grading queue', :js => true do

  before :each do
    @faculty_fagan=FactoryGirl.create(:faculty_fagan_user)
    @student_sally= FactoryGirl.create(:student_sally_user)
    @student_sam= FactoryGirl.create(:student_sam_user)
    @team_triumphant=FactoryGirl.create(:team_triumphant,:members=>[@student_sally],:primary_faculty=>@faculty_fagan)
    @team_bean_counters=FactoryGirl.create(:team_bean_counters,:members=>[@student_sam],:primary_faculty=>@faculty_fagan)
    @course = FactoryGirl.create(:fse_current_semester)
    @faculty_assignment = FactoryGirl.create(:faculty_assignment,:user=>@faculty_fagan, :course=>@course)
    @course.faculty_assignments<<@faculty_assignment


    @individual_assignment1 = FactoryGirl.create(:assignment_fse2,:name=>'Individual Assignment 1', :course=>@course)
    @deliverable2 = FactoryGirl.create(:individual_deliverable2,:assignment=>@individual_assignment1,:course=>@course,:creator=>@student_sally)
    @deliverable_attachment1 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable2,:submitter=>@student_sally)
    
    @individual_assignment2 = FactoryGirl.create(:assignment_fse,:name=>'Individual Assignment 2', :course=>@course)
    @deliverable1 = FactoryGirl.create(:individual_deliverable1,:assignment=>@individual_assignment2,:course=>@course,:creator=>@student_sam)
    @deliverable_attachment2 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable1,:submitter=>@student_sam)
    
    @team_assignment1 = FactoryGirl.create(:assignment_team, :name=>'Team Assignment 1', :course=>@course)
    @deliverable3 = FactoryGirl.create(:team_deliverable, :assignment=>@team_assignment1,:course=>@course,:team=>@team_triumphant,:creator=>@student_sally)
    @deliverable_attachment3 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable3,:submitter=>@student_sally)
    
    @team_assignment2 = FactoryGirl.create(:assignment_team, :name=>'Team Assignment 1', :course=>@course)
    @deliverable4 = FactoryGirl.create(:team_deliverable, :assignment=>@team_assignment2,:course=>@course,:team=>@team_bean_counters,:creator=>@student_sam)
    @deliverable_attachment3 = FactoryGirl.create(:deliverable_attachment,:deliverable=>@deliverable4,:submitter=>@student_sam)
    login_with_oauth @faculty_fagan
    visit course_deliverables_path(@course)
   end
  
   it 'Can sort by individual/team name' do
     # Grab the "Names" column: http://stackoverflow.com/questions/14745478/how-to-select-table-column-by-column-header-name-with-xpath
     unsorted_names = all(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th[.='Name']/preceding-sibling::th)+1]").collect { |x| x.text }
     
     # Click "Names" so deliverables are sorted
     find(:xpath, "//th", :text => "Name").click
     
     # Test that the rows are now sorted
     (all(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th[.='Name']/preceding-sibling::th)+1]").collect { |x| x.text }).should == unsorted_names.sort
   end

  it 'Can sort by assignment' do
     unsorted_assg = all(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th[.='Assignment']/preceding-sibling::th)+1]").collect { |x| x.text }
     find(:xpath, "//th", :text => "Assignment").click
     (all(:xpath, "//table/tbody/tr/td[count(//table/thead/tr/th[.='Assignment']/preceding-sibling::th)+1]").collect { |x| x.text }).should == unsorted_assg.sort
   end

 end

