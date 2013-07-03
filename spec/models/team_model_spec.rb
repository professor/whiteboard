require 'spec_helper'

describe Team do

  context 'updates google mailing list' do
    before do
      @team = FactoryGirl.create(:team_triumphant)
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
        @student = FactoryGirl.create(:student_sally)
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
      FactoryGirl.create(:team)
    }.should change(Team, :count).by(1)
  end

  context "has peer evaluation date" do
    it "first email that is copied from the course's peer evaluation first email date if it exists" do
      course = FactoryGirl.create(:course, :peer_evaluation_first_email => Date.today)
      team = FactoryGirl.create(:team, :course_id => course.id)

      team.peer_evaluation_first_email.to_date.should == course.peer_evaluation_first_email
    end

    it "first email that is not overwritten if the faculty has already specified a peer evaluation date" do
      course = FactoryGirl.create(:course, :peer_evaluation_first_email => Date.today)
      team = FactoryGirl.create(:team, :course_id => course.id, :peer_evaluation_first_email => 4.hours.from_now)
      course.peer_evaluation_first_email = 1.day.ago
      team.save
      team.peer_evaluation_first_email == 4.hours.from_now
    end

    it "second email that is copied from the course's peer evaluation second email date if it exists" do
      course = FactoryGirl.create(:course, :peer_evaluation_second_email => Date.today)
      team = FactoryGirl.create(:team, :course_id => course.id)

      team.peer_evaluation_second_email.to_date.should == course.peer_evaluation_second_email
    end

    it "second email that is not overwritten if the faculty has already specified a peer evaluation date" do
      course = FactoryGirl.create(:course, :peer_evaluation_second_email => Date.today)
      team = FactoryGirl.create(:team, :course_id => course.id, :peer_evaluation_second_email => 4.hours.from_now)
      course.peer_evaluation_second_email = 1.day.ago
      team.save
      team.peer_evaluation_second_email == 4.hours.from_now
    end


  end

  #When modifying this test, please examine the same for course
  context "when adding users to a team by providing their names as strings" do
    before(:each) do
       @team = FactoryGirl.build(:team)
       @student_sam = FactoryGirl.build(:student_sam_user, :id => rand(100))
       @student_sally = FactoryGirl.build(:student_sally_user, :id => rand(100) + 100)
       User.stub(:find_by_human_name).with(@student_sam .human_name).and_return(@student_sam )
       User.stub(:find_by_human_name).with(@student_sally.human_name).and_return(@student_sally)
       User.stub(:find_by_human_name).with("Someone not in the system").and_return(nil)
  end

    it "validates that the people are in the system" do
      @team.members_override = [@student_sam.human_name, @student_sally.human_name]
      @team.validate_team_members
      @team.should be_valid
    end

    it "for people not in the system, it sets an error" do
      @team.members_override = [@student_sam.human_name, "Someone not in the system", @student_sally.human_name]
      @team.validate_team_members
      @team.should_not be_valid
      @team.errors[:base].should include("Person Someone not in the system not found")
    end

    it "assigns them to the people association" do
      @team.members_override = [@student_sam.human_name, @student_sally.human_name]
      @team.update_members
      @team.members[0].should == @student_sam
      @team.members[1].should == @student_sally
    end
  end

  context "is_person_on_team?" do

   before(:each) do
      @faculty_frank = FactoryGirl.create(:faculty_frank_user)
      @student_sam = FactoryGirl.create(:student_sam_user)
      @student_sally = FactoryGirl.create(:student_sally_user)
      @course = FactoryGirl.create(:course)
      @team = FactoryGirl.create(:team, :course_id => @course.id, :name => "Dracula", :members => [@student_sam, @student_sally])
    end

    it "correctly determines whether a user is on the team" do
      @team.is_user_on_team?(@student_sam).should be_true
      @team.is_user_on_team?(@student_sally).should be_true
      @team.is_user_on_team?(@faculty_frank).should be_false
    end
  end

#these tests are the same with course
 context 'generated email address' do
   it 'should use the short name if available' do
     team = FactoryGirl.build(:team_triumphant, :course => FactoryGirl.build(:mfse_fall_2011))
     team.update_email_address
     team.email.should == "fall-2011-team-triumphant@" + GOOGLE_DOMAIN
   end

   it 'should convert unusual characters to ones that google can handle' do
     team = FactoryGirl.build(:team_triumphant, :course => FactoryGirl.build(:mfse_fall_2011))
     team.name = "A T & T"
     team.update_email_address
     team.email.should == "fall-2011-a-t-and-t@" + GOOGLE_DOMAIN
   end
 end


end
