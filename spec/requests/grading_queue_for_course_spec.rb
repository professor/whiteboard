require 'spec_helper'

describe 'When I visit the grading queue page,' do
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

  context 'as a professor, it ' do
    before :each do
      url = "/courses/#{@course.id}/deliverables?teams=my_teams"
      visit(url)
    end

    # Write a set of test cases to check for basic content
    # that needs to be displayed no matter what on the page.
    it 'should have a search text box ' do
      page.should have_content('filterBoxOne')
    end

    it 'should have a radio button group which has two items: My Team and All' do
      page.should have_content('My Teams')
      page.should have_content('All Teams')
    end

    it 'should have a list box showing Assignments for the course ' do
      page.should have_content('Assignment:')
      page.should have_content('#selected_assignment')
      find_field('selected_assignment').should have_content('All')
      find_field('selected_assignment').should have_content(@team_assignment.name)
      find_field('selected_assignment').should have_content(@indi_assignment.name)
    end

    it 'should have checkboxes that provide different filtering conditions by assignment status' do
      page.should have_css('#filter_ungraded')
      page.should have_css('#filter_graded')
      page.should have_css('#filter_drafted')
    end

    it 'should have two links named - Team Deliverables and Individual Deliverables' do
      page.should have_link('Team Deliverables')
      page.should have_link('Individual Deliverables')
    end

    it 'should have two divs which display team deliverables and individual deliverables separately ' do
      page.should have_content('Team Deliverables')
      page.should have_content('Individual Deliverables')
    end

    # Now check for default selections that need to happen
    it 'should have My Teams selected by default' do
      # Check for My Teams vs All Teams radio button selection
      page.should have_checked_field('filter_my_teams')
      page.should_not have_checked_field('filter_all_teams')
    end

    it 'should have All selected under Assignments select one box' do
      # Check for Assignment: select one box content
      find('#selected_assignment').value.should eq '-1'
    end

    it 'should have Ungraded, Drafted selected for grading status check boxes' do
      # Check for grading status check box selections
      page.should have_unchecked_field('filter_graded')
      page.should have_checked_field('filter_ungraded')
      page.should have_checked_field('filter_drafted')
    end

    context 'should display my teams content ' do
      it 'under team deliverables table' do
        # Content we expect to see on the page
        find('div#teamDelDiv').text.should have_content(@deliverable_1.assignment.name)
        find('div#teamDelDiv').text.should have_content(@deliverable_1.team.name)
        find('div#teamDelDiv').text.should have_content(@deliverable_1.team.primary_faculty.human_name)
        find('div#teamDelDiv').text.should have_content('Give Grade')

        # Content that should not be displayed
        find('div#teamDelDiv').text.should_not have_content(@indi_assignment.name)
        find('div#teamDelDiv').text.should_not have_content(@team_bean_counters.name)
        find('div#teamDelDiv').text.should_not have_content(@faculty_fagan.human_name)
        find('div#teamDelDiv').text.should_not have_content('Review Grade')
      end

      it "should have a column that indicates the grading status of each assignment" do
        page.should have_css('#tab-1', :text => 'Indicator')
        save_and_open_page
        page.should have_css('#ungraded', :count => 1)
      end
    end

=begin
    it "should display all teams when clicking on All Teams radio button" do
      page.choose('filter_all_teams')
      visit("/courses/#{@course.id}/deliverables?teams=all_teams")
      save_and_open_page
      # Content we expect to see on the page
      find('div#teamDelDiv').text.should have_content(@deliverable_1.assignment.name)
      find('div#teamDelDiv').text.should have_content(@deliverable_1.team.name)
      find('div#teamDelDiv').text.should have_content(@deliverable_1.team.primary_faculty.human_name)
      find('div#teamDelDiv').text.should have_content(@deliverable_2.assignment.name)
      find('div#teamDelDiv').text.should have_content(@deliverable_2.team.name)
      find('div#teamDelDiv').text.should have_content(@deliverable_2.team.primary_faculty.human_name)
    end
=end

  end
end
