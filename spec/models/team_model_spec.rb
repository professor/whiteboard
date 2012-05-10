require 'spec_helper'

describe Team do

  context 'updates google mailing list' do
    before do
      @team = Factory.create(:team_triumphant)
      @team.updating_email = false
      @count = Delayed::Job.count
    end

    context 'when the team name changes' do
      before do
        @team.name = "Team Awesome"
        @team.save
      end
      it 'adds an asynchronous request' do
        Delayed::Job.count.should > @count
      end
      it 'marks the state transition' do
        @team.updating_email.should == true
      end
      it 'updates the course mailing list' do
        @team.course.updating_email.should == true
      end
    end

    context 'when the members changes' do
      before do
        @student = Factory(:student_sally)
        @team.members_override = [@student.human_name]
        @team.save
      end
      it 'adds an asynchronous request' do
        Delayed::Job.count.should > @count
      end
      it 'marks the state transition' do
        @team.updating_email.should == true
      end
      it 'updates the course mailing list' do
        @team.course.updating_email.should == true
      end
    end

    context 'but not when the faculty changes' do
      before do
        @team.primary_faculty_id = 1
        @team.save
      end
      it 'does not add an asynchronous request' do
        Delayed::Job.count.should == @count
      end
      it 'a state transition does not happen' do
        @team.updating_email.should == false
      end
    end
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

  #When modifying this test, please examine the same for course
  context "when adding users to a team by providing their names as strings" do
    before(:each) do
       @team = Factory.build(:team)
       @student_sam = Factory.build(:student_sam, :id => rand(100))
       @student_sally = Factory.build(:student_sally, :id => rand(100) + 100)
       Person.stub(:find_by_human_name).with(@student_sam .human_name).and_return(@student_sam )
       Person.stub(:find_by_human_name).with(@student_sally.human_name).and_return(@student_sally)
       Person.stub(:find_by_human_name).with("Someone not in the system").and_return(nil)
  end

    it "validates that the people are in the system" do
      @team.members_override = [@student_sam .human_name, @student_sally.human_name]
      @team.validate_members
      @team.should be_valid
    end

    it "for people not in the system, it sets an error" do
      @team.members_override = [@student_sam .human_name, "Someone not in the system", @student_sally.human_name]
      @team.validate_members
      @team.should_not be_valid
      @team.errors[:base].should include("Person Someone not in the system not found")
    end

    it "assigns them to the people association" do
      @team.members_override = [@student_sam.human_name, @student_sally.human_name]
      @team.update_members
      @team.people[0].should == @student_sam
      @team.people[1].should == @student_sally
    end
  end

  context "is_person_on_team?" do

   before(:each) do
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
