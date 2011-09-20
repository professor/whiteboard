require 'spec_helper'

describe Team do

  it "should throw an error when a google distribution list was not created" do
    google_apps_connection.stub(:create_group)
    google_apps_connection.stub(:add_member_to_group)

    team = Factory.create(:team_triumphant)
    lambda { team.update_google_mailing_list("new", "old", 123) }.should raise_error()


  end

  it 'can be created' do
    lambda {
      Factory(:team)
    }.should change(Team, :count).by(1)
  end


  context "has peer evaluation date" do
    it "first email that is copied from the course's peer evaluation first email date if it exists" do
      course = Factory(:course, :peer_evaluation_first_email => Date.today)
      team = Factory(:team, :course_id => course.id)

      team.peer_evaluation_first_email.to_date.should == course.peer_evaluation_first_email
    end

    it "first email that is not overwritten if the faculty has already specified a peer evaluation date" do
      course = Factory(:course, :peer_evaluation_first_email => Date.today)
      team = Factory(:team, :course_id => course.id, :peer_evaluation_first_email => 4.hours.from_now)
      course.peer_evaluation_first_email = 1.day.ago
      team.save
      team.peer_evaluation_first_email == 4.hours.from_now
    end

    it "second email that is copied from the course's peer evaluation second email date if it exists" do
      course = Factory(:course, :peer_evaluation_second_email => Date.today)
      team = Factory(:team, :course_id => course.id)

      team.peer_evaluation_second_email.to_date.should == course.peer_evaluation_second_email
    end

    it "second email that is not overwritten if the faculty has already specified a peer evaluation date" do
      course = Factory(:course, :peer_evaluation_second_email => Date.today)
      team = Factory(:team, :course_id => course.id, :peer_evaluation_second_email => 4.hours.from_now)
      course.peer_evaluation_second_email = 1.day.ago
      team.save
      team.peer_evaluation_second_email == 4.hours.from_now
    end


  end

  context "is_person_on_team?" do

   before do
      @faculty_frank = Factory(:faculty_frank)
      @student_sam = Factory(:student_sam)
      @student_sally = Factory(:student_sally)
      @course = Factory(:course, :configure_teams_name_themselves => false)
      @team = Factory(:team, :course_id => @course.id, :name => "Dracula", :people => [@student_sam, @student_sally])
    end

    it "correctly determines whether a person is on the team" do
      @team.is_person_on_team?(@student_sam).should be_true
      @team.is_person_on_team?(@student_sally).should be_true
      @team.is_person_on_team?(@faculty_frank).should be_false
    end
  end

end
