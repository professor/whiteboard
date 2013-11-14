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
    @course.registered_students << @student_sally
    @course.registered_students << @student_sam
    @faculty_assignment_1 = FactoryGirl.create(:faculty_assignment, :user => @faculty_frank, :course => @course)
    @faculty_assignment_2 = FactoryGirl.create(:faculty_assignment, :user => @faculty_fagan, :course => @course)
    @course.faculty_assignments << @faculty_assignment_1
    @course.faculty_assignments << @faculty_assignment_2

    # Create an assignment for the course
    @team_assignment = FactoryGirl.create(:assignment, :name => 'Team Assignment 1', :is_team_deliverable => true, :course => @course)
    @indi_assignment = FactoryGirl.create(:assignment, :name => 'Individual Assignment', :course => @course)

    # Creating teams
    @team_triumphant = FactoryGirl.create(:team_triumphant, :members => [@student_sally], :primary_faculty => @faculty_frank, :course => @course)
    @team_bean_counters = FactoryGirl.create(:team_bean_counters, :members => [@student_sam], :primary_faculty => @faculty_fagan, :course => @course)

    # Team Deliverables
    @deliverable_1 = FactoryGirl.create(:deliverable, :assignment => @team_assignment, :team => @team_triumphant, :course => @course, :creator => @student_sally)
    @deliverable_1_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_1, :submitter => @student_sally)
    @deliverable_2 = FactoryGirl.create(:deliverable, :assignment => @team_assignment, :team => @team_bean_counters, :course => @course, :creator => @student_sam)
    @deliverable_2_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_2, :submitter => @student_sam)

    # Individual Deliverables
    @deliverable_3 = FactoryGirl.create(:deliverable, :assignment => @indi_assignment, :course => @course, :creator => @student_sally)
    @deliverable_3_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_3, :submitter => @student_sally)
    @deliverable_4 = FactoryGirl.create(:deliverable, :assignment => @indi_assignment, :course => @course, :creator => @student_sam)
    @deliverable_4_attachment = FactoryGirl.create(:deliverable_attachment, :deliverable => @deliverable_4, :submitter => @student_sam)

    login_with_oauth @faculty_frank
  end

  context 'as a professor, it ' do
    before :each do
      url = "/courses/#{@course.id}/deliverables?teams=my_teams"
      visit(url)
    end

    # Write a set of test cases to check for basic content
    # that needs to be displayed no matter what on the page.
    it 'should have a search text box' do
      page.should have_content('filterBoxOne')
    end

    it 'should have a radio button group which has two items: My Team and All' do
      page.should have_content('My Teams')
      page.should have_content('All Teams')
    end

    it 'should have a list box showing Assignments for the course' do
      page.should have_content('Assignment:')
      page.should have_content('#selected_assignment')

      area = find_field('selected_assignment')
      area.should have_content('All')
      area.should have_content(@team_assignment.name)
      area.should have_content(@indi_assignment.name)
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

    it 'should have two divs which display team deliverables and individual deliverables separately' do
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
        area = find('div#teamDelDiv').text

        # Content we expect to see on the page
        area.should have_content(@deliverable_1.assignment.name)
        area.should have_content(@deliverable_1.team.name)
        area.should have_content(@deliverable_1.team.primary_faculty.human_name)
        area.should have_content('Give Grade')

        # Content that should not be displayed
        area.should_not have_content(@indi_assignment.name)
        area.should_not have_content(@team_bean_counters.name)
        area.should_not have_content(@faculty_fagan.human_name)
        area.should_not have_content('Review Grade')
      end

      it 'under a table that has a column that indicates the grading status' do
        page.should have_css('#tab-1', :text => 'Indicator')
      end
    end

    context 'should show assignment which I select in the drop down, either ' do
      it 'only the team assignments' do
        page.select('Team Assignment', :from => 'selected_assignment')
        Capybara.default_wait_time = 3
        page.should have_content('No Individual deliverables match the selected filter criteria.')
        find('div#teamDelDiv').text.should_not have_content('No Team deliverables match the selected filter criteria.')
      end

      it 'only the individual assignments' do
        page.select('Individual Assignment', :from => 'selected_assignment')
        Capybara.default_wait_time = 5
        page.should have_content('No Team deliverables match the selected filter criteria.')
        find('div#indiDelDiv').text.should_not have_content('No Individual deliverables match the selected filter criteria.')
        page.should have_content('Individual Assignment')
      end

      it 'show all the assignments' do
        page.select('All', :from => 'selected_assignment')
        area = find('div#teamDelDiv').text
        Capybara.default_wait_time = 3
        area.should_not have_content('No Team deliverables match the selected filter criteria.')
        area.should_not have_content('No Team deliverables match the selected filter criteria.')
        area.should have_content(@team_assignment.name)
      end
    end

    context 'should show all team either when ' do
       it 'the radio button All Teams is schosen' do
        choose('filter_all_teams')
        
        # Content we expect to see on the page
        area = find('div#teamDelDiv').text
        area.should have_content(@deliverable_1.assignment.name)
        area.should have_content(@deliverable_1.team.name)
        area.should have_content(@deliverable_1.team.primary_faculty.human_name)
        area.should have_content('Give Grade')
      end

      it 'the param teams equals to all_teams' do
        visit("/courses/#{@course.id}/deliverables?teams=all_teams")

        # Content we expect to see on the page
        area = find('div#teamDelDiv').text
        area.should have_content(@deliverable_1.assignment.name)
        area.should have_content(@deliverable_1.team.name)
        area.should have_content(@deliverable_1.team.primary_faculty.human_name)
        area.should have_content(@deliverable_2.assignment.name)
        area.should have_content(@deliverable_2.team.name)
        area.should have_content(@deliverable_2.team.primary_faculty.human_name)
      end
    end

    describe 'should hava a tab, which ', :js => true do
        before :each do
          @area = page.find_by_id('teamDelDiv').find('tr.twikiTableOdd.ungraded')
          @area.find('div#ungraded').click
        end

        it "shows the grading page of an assignment when I click on it " do
          id = "#" + @deliverable_1.id.to_s
          page.should have_css(id)
        end
       
        context "shows the grading page of an assignment that " do

          it "enables me to grade and save grades for team deliverables " do
            id = "#" + @deliverable_1.id.to_s
            page.find(id).fill_in('team_grade', :with => '5')
            page.find("[name=draft]").click

            visit("/courses/#{@course.id}/deliverables")

            page.find('div#drafted').click
            page.should have_field(@student_sally.id.to_s, :value => 5)
          end
        end
    end
  end
end
