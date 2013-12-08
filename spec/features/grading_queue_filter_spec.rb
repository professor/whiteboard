require 'spec_helper'
include IntegrationSpecHelper

describe 'Grading queue', :skip_on_build_machine => true, :js => true do

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
    @grade1 = FactoryGirl.create(:grade1,:course=>@course,:student=>@student_sally,:assignment=>@individual_assignment1)
       
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

  it 'Shows both teams and individuals by default' do
   find('div#show-individuals')[:class].should == 'filter active'
   find('div#show-individuals')[:class].should == 'filter active'
  end

  it 'Shows ungraded and drafted, but not graded, deliverables by default' do
    find('div#show-ungraded')[:class].should == 'filter active'
    find('div#show-drafted')[:class].should == 'filter active'
    find('div#show-graded')[:class].should == 'filter'
  end
  
  it 'Can filter by individual' do
    page.should have_css('div.name', :text => 'Student Sam', :visible => true)
    find('div#show-individuals').click
    page.should_not have_css('div.name', :text => 'Student Sam', :visible => true)
  end

  it 'Can filter by team' do
    page.should have_css('div.name', :text => 'Team Bean Counters', :visible => true)
    find('div#show-teams').click
    page.should_not have_css('div.name', :text => 'Team Bean Counters', :visible => true)
  end

  it 'Can filter by ungraded' do
    pending
    find('div#show-ungraded').click
  end
  
  it 'Can filter by graded' do
    pending
    save_and_open_page
    find('div#show-graded').click
    save_and_open_page
  end

end
