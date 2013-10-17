require 'spec_helper'

describe "deliverables/grading_queue_for_course" do
  before :each do
    @faculty = FactoryGirl.create(:faculty_frank)
    login_with_oauth @faculty
    @course = FactoryGirl.create(:fse)
    @course.faculty = [@faculty]
#    @team = FactoryGirl.create(:team_triumphant)
#    @team.course_id = [@course.id]
#    @team.primary_faculty_id = [@faculty.id]

    @assignment = FactoryGirl.create(:assignment_team)
    @assignment.name = "Assignment 1"

    @deliverable = FactoryGirl.create(:team_deliverable)
    @deliverable.course_id = [@course.id]
    @deliverable.name = "FSE Deliverable 1"

    @deliverable.creator_id = [@faculty.id]
    @deliverable.assignment_id = [@assignment.id]

    visit ("/courses/#{@course.id}/deliverables")
  end

  it "should have a radio button group which has two items: My Team and All" do
    expect(page).to have_content("My Teams")
    expect(page).to have_content("All Teams")
  end

  it "should have a column that indicates who is responsible for grading this deliverable" do
#    expect(page).to have_content("Advisor")    
  end

#TODO
  it "should response after selecting one of the radio button" do
#    choose('filter_my_teams')
#    expect(page).to have_content("todo")
  end

  it "should shows deliverables" do
#    expect(page).to have_content("FSE Deliverable 1")
  end

end
