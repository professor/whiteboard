require 'spec_helper'

describe "deliverables/grading_queue_for_course" do
  before :each do
    @faculty = FactoryGirl.create(:faculty_smith_user)
    login_with_oauth @faculty
    @course = FactoryGirl.create(:fse)
    @course.faculty = [@faculty]
    visit ("/courses/#{@course.id}/deliverables")
  end

  it "should have a radio button group which has two items: My Team and All" do
    expect(page).to have_content("My Teams")
    expect(page).to have_content("All Teams")
  end

  it "should have a column that indicates who is reponsible for grading this deliverable" do
    expect(page).to have_content("Advisor")    
  end

#TODO
  it "should response after selecting one of the radio button" do
    choose('filter_my_teams')
    expect(page).to have_content("todo")
  end



end
