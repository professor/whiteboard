require 'spec_helper'

describe Deliverable do

  it 'can be created' do
    lambda {
      FactoryGirl.create(:deliverable)
    }.should change(Deliverable, :count).by(1)
  end

  context "is valid" do
    before(:each) do
      @deliverable = FactoryGirl.build(:deliverable)
    end
  end

  context "is not valid" do

    [:course, :assignment, :creator].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    context "when a duplicate deliverable for the same course, assignment and owner" do
      [:team_deliverable, :individual_deliverable].each do |symbol|
        it "for a team/individual deliverable" do
          original = FactoryGirl.build(symbol)
          original.stub(:update_team)
          original.save
          duplicate = Deliverable.new()
          duplicate.stub(:update_team)
          duplicate.creator_id = original.creator_id
          duplicate.assignment = original.assignment
          duplicate.team_id = original.team_id
          duplicate.should_not be_valid
        end
      end
    end
  end

  it "should return team name for a team deliverable" do
    deliverable = FactoryGirl.build(:team_deliverable)
    deliverable.stub(:update_team)
    deliverable.save
    deliverable.owner_name.should be_equal(deliverable.team.name)
  end

    it "should return person name for a individual deliverable" do
    deliverable = FactoryGirl.create(:individual_deliverable)
    deliverable.owner_name.should be_equal(deliverable.creator.human_name)
  end

  it "should return team email for a team deliverable" do
    deliverable = FactoryGirl.build(:team_deliverable)
    deliverable.stub(:update_team)
    deliverable.save
    deliverable.owner_email.should be_equal(deliverable.team.email)
  end

  it "should return person email for a individual deliverable" do
    deliverable = FactoryGirl.create(:individual_deliverable)
    deliverable.owner_email.should be_equal(deliverable.creator.email)
  end

  context "has_feedback?" do
  it "returns false when there is no feedback" do
    subject.has_feedback?.should be_false

#!(self.feedback_comment.nil? or self.feedback_comment == "") or !self.feedback_file_name.nil?
  end

  it "returns true when there is a comment" do
    subject.feedback_comment = "Great job team!"
    subject.has_feedback?.should be_true
  end

  it "returns true when there is a file" do
    subject.feedback_file_name = "/somewhere_on_s3/somewhere_over_the_rainbow/amazing_feedback.txt"
    subject.has_feedback?.should be_true
  end


  end

  context "for a team" do
    before(:each) do
      @deliverable = FactoryGirl.build(:team_deliverable)
      @team_member = @deliverable.team.members[0]
    end

    it "is not editable by any random student" do
      @deliverable.editable?(FactoryGirl.create(:student_sally, :email=>"student.sally2@sv.cmu.edu", :webiso_account =>"ss2@andrew.cmu.edu")).should be_false
    end

    it "is editable by staff or admin" do
      @deliverable.editable?(FactoryGirl.create(:faculty_frank)).should be_true
     end

    it "is editable by a team member" do
      @deliverable.editable?(@team_member).should be_true
    end
  end

  context "for an individual deliverable" do
    before(:each) do
      @deliverable = FactoryGirl.build(:individual_deliverable)
      @individual = @deliverable.creator
    end

    it "is not editable by any random student" do
      @deliverable.editable?(FactoryGirl.create(:student_sally, :email=>"student.sally2@sv.cmu.edu", :webiso_account =>"ss2@andrew.cmu.edu")).should be_false
    end

    it "is editable by staff or admin" do
      @deliverable.editable?(FactoryGirl.create(:faculty_frank)).should be_true
     end

    it "is editable by its owner" do
      @deliverable.editable?(@individual).should be_true
    end
  end

  context "for an individual deliverable's grading status" do
    before(:each) do
      @deliverable = FactoryGirl.build(:individual_deliverable)
    end

    it "is visible if the grade is published" do
      grade = FactoryGirl.build(:grade_visible)
      Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(grade)
      @deliverable.is_visible_to_student?.should be_true
    end

    it "is invisible if the grade is not published" do
      grade = FactoryGirl.build(:grade_invisible)
      Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(grade)
      @deliverable.is_visible_to_student?.should be_false
    end

    it "is invisible if it is not graded" do
      Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(nil)
      @deliverable.is_visible_to_student?.should be_false
    end

    #it "is graded if grade is given and published" do
    #  grade = FactoryGirl.build(:grade_visible)
    #  Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(grade)
    #  @deliverable.get_grade_status.should eq(:graded)
    #end

    #it "is ungraded if grade is not given" do
    #  Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(nil)
    #  @deliverable.get_grade_status.should eq(:ungraded)
    #end
    #
    #it "is drafted if grade is given but not published" do
    #  grade = FactoryGirl.build(:grade_invisible)
    #  Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(grade)
    #  @deliverable.get_grade_status.should eq(:drafted)
    #end
  end

  #context "for a team deliverable's grading status" do
  #  before(:each) do
  #    @deliverable = FactoryGirl.build(:team_deliverable)
  #  end
  #
    #it "is graded if all of members' grades are given and published" do
    #  @deliverable.team.members.each do | member |
    #    grade = FactoryGirl.build(:grade_visible, :student_id => member.id)
    #    Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, member.id).and_return(grade)
    #  end
    #  @deliverable.get_grade_status.should eq(:graded)
    #end
    #
    #it "is drafted if any of the member's grade is given but not published" do
    #  grade = FactoryGirl.build(:grade_invisible)
    #  @deliverable.team.members.each do | member |
    #    grade = FactoryGirl.build(:grade_invisible, :student_id => member.id)
    #    Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, member.id).and_return(grade)
    #  end
    #  @deliverable.get_grade_status.should eq(:drafted)
    #end
    #
    #it "is ungraded if any of the member's grade is not given" do
    #  @deliverable.team.members.each do | member |
    #    Grade.stub(:get_grade).with(@deliverable.course.id, @deliverable.assignment.id, member.id).and_return(nil)
    #  end
    #  @deliverable.get_grade_status.should eq(:ungraded)
    #end
  #end

  context "for a professor" do
    before (:each) do
      @faculty_frank = FactoryGirl.build(:faculty_frank_user)
      @course_fse = FactoryGirl.create(:fse, faculty: [@faculty_frank])
      @course_ise = FactoryGirl.create(:ise, faculty: [@faculty_frank])
      @student_sam = FactoryGirl.create(:student_sam)
      @student_sally = FactoryGirl.create(:student_sally)
      @team_member = FactoryGirl.create(:team_member)
    end

    it "Displays the professor's teams deliverables if the professor has at least one team" do
      @team_turing =  FactoryGirl.create(:team_turing, :course=>@course_fse)
      @team_test =  FactoryGirl.create(:team_test, :course=>@course_fse)
      @team_assignment = FactoryGirl.create(:team_turing_assignment, :team => @team_turing, :user => @student_sam)

      @assignment_team_turing_1 = FactoryGirl.create(:assignment_1,:course => @course_fse)
      @assignment_team_turing_2 = FactoryGirl.create(:assignment_1,:course => @course_fse)
      @assignment_team_test_1 = FactoryGirl.create(:assignment_1,:course => @course_fse)


      @team_turing_deliverable_1 = FactoryGirl.create(:team_turing_deliverable_1,:course => @course_fse,
                            :team => @team_turing,:assignment => @assignment_team_turing_1, :creator => @student_sam)
      @team_turing_deliverable_2 = FactoryGirl.create(:team_turing_deliverable_1,:course => @course_fse,
                            :team => @team_turing,:assignment => @assignment_team_turing_2, :creator => @student_sam)
      @team_test_deliverable_1 = FactoryGirl.create(:team_test_deliverable_1,:course => @course_fse,
                             :team => @team_test,:assignment => @assignment_team_test_1)

      @attachment_deliverable_1_turing =  FactoryGirl.create(:attachment_1, :deliverable => @team_turing_deliverable_1,
                                                             :submitter => @student_sam)
      @attachment_deliverable_2_turing =  FactoryGirl.create(:attachment_1, :deliverable => @team_turing_deliverable_2,
                                                             :submitter => @student_sam)
      @attachment_deliverable_1_test =  FactoryGirl.create(:attachment_1, :deliverable => @team_test_deliverable_1,
                                                           :submitter => @student_sam)

      @options = {:is_my_team => 1}

      @expected_deliverables = Deliverable.get_deliverables(@course_fse.id, @faculty_frank.id, @options)
      @expected_deliverables.should have(2).items

      @expected_deliverables[1].should == @team_turing_deliverable_2
      @expected_deliverables[0].should == @team_turing_deliverable_1

    end

    it "Displays the professor's students individual deliverables if the professor has at least one team" do
      @team_turing =  FactoryGirl.create(:team_turing, :course=>@course_fse)
      @team_test =  FactoryGirl.create(:team_test, :course=>@course_fse)

      #Assigning the student to the team
      @team_turing_assignment = FactoryGirl.create(:team_turing_assignment, :team => @team_turing,
                                                   :user => @student_sam)
      @team_test_assignment = FactoryGirl.create(:team_test_assignment, :team => @team_test, :user => @student_sally)

      @assignment_team_turing_1 = FactoryGirl.create(:assignment_3,:course => @course_fse)
      @assignment_team_turing_2 = FactoryGirl.create(:assignment_3,:course => @course_fse)

      @turing_individual_deliverable_1 = FactoryGirl.create(:turing_individual_deliverable,:course => @course_fse,
                              :assignment => @assignment_team_turing_1, :creator => @student_sam)
      @turing_individual_deliverable_2 = FactoryGirl.create(:test_individual_deliverable,:course => @course_fse,
                              :assignment => @assignment_team_turing_2, :creator => @student_sally)

      @attachment_deliverable_1_turing =  FactoryGirl.create(:attachment_1, :deliverable =>
                              @turing_individual_deliverable_1, :submitter => @student_sam)
      @attachment_deliverable_2_turing =  FactoryGirl.create(:attachment_1, :deliverable =>
                              @turing_individual_deliverable_2, :submitter => @student_sally)

      @options = {:is_my_team => 1}

      @expected_deliverables = Deliverable.get_deliverables(@course_fse.id, @faculty_frank.id, @options)
      @expected_deliverables.should have(1).items

      @expected_deliverables[0].should == @turing_individual_deliverable_1
    end

    it "If a course has teams, display team deliverables as well as individual deliverables for students in the
        faculty's team" do

      @team_turing =  FactoryGirl.create(:team_turing, :course => @course_fse)
      @team_test =  FactoryGirl.create(:team_test, :course => @course_fse)

      @team_assignment = FactoryGirl.create(:team_turing_assignment, :team => @team_turing, :user => @student_sam)
      @team_assignment = FactoryGirl.create(:team_test_assignment, :team => @team_test, :user => @student_sally)

      @assignment1 = FactoryGirl.create(:assignment_3,:course => @course_fse)
      @assignment2 = FactoryGirl.create(:assignment_3,:course => @course_fse)

      # Team deliverable
      @deliverable1 = FactoryGirl.create(:team_turing_deliverable_1,:course => @course_fse, :team => @team_turing,:assignment => @assignment1, :creator => @student_sam)
      # Individual deliverable 1
      @deliverable2 = FactoryGirl.create(:turing_individual_deliverable,:course => @course_fse, :assignment => @assignment1, :creator => @student_sam)
      # Individual deliverable 2
      @deliverable3 = FactoryGirl.create(:test_individual_deliverable,:course => @course_fse, :assignment => @assignment2, :creator => @student_sally)

      @dav1 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable1, :submitter => @student_sam)
      @dav2 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable2, :submitter => @student_sam)
      @dav3 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable3, :submitter => @student_sally)

      @options = {:is_my_team => 1}
      @deliverables = Deliverable.get_deliverables(@course_fse.id, @faculty_frank.id, @options)
      @deliverables.should have(2).items

      @deliverables[0].should == @deliverable1
      @deliverables[1].should == @deliverable2

    end

    it "Displays all deliverables if the course does not have teams" do

      @deliverable1 = FactoryGirl.create(:turing_individual_deliverable, :course=>@course_fse)
      #@deliverable2 = FactoryGirl.create(:individual_deliverable, :course=>@course_ise)
      @dav3 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable1, :submitter => @student_sam)

      @options = {:is_my_team => 1}
      @deliverables = Deliverable.get_deliverables(@course_fse.id, @faculty_frank.id, @options)
      @deliverables.should have(1).items
      @deliverables[0].should == @deliverable1

    end

    it "If a course has teams and user enter search terms, display team deliverables as well as individual deliverables
        for students in the faculty's team" do

      @team_turing =  FactoryGirl.create(:team_turing, :course => @course_fse)
      @team_test =  FactoryGirl.create(:team_test, :course => @course_fse)
      @team_ruby_racer =  FactoryGirl.create(:team_ruby_racer, :course => @course_fse)

      @team_assignment = FactoryGirl.create(:team_turing_assignment, :team => @team_turing, :user => @student_sam)
      @team_assignment = FactoryGirl.create(:team_test_assignment, :team => @team_test, :user => @student_sally)
      @team_assignment = FactoryGirl.create(:team_ruby_racer_assignment, :team => @team_ruby_racer, :user => @team_member)

      @assignment1 = FactoryGirl.create(:assignment_3,:course => @course_fse)
      @assignment2 = FactoryGirl.create(:assignment_3,:course => @course_fse)

      # Team deliverable
      @deliverable1 = FactoryGirl.create(:team_turing_deliverable_1,:course => @course_fse, :team => @team_turing,:assignment => @assignment1, :creator => @student_sam)
      # Individual deliverable 1
      @deliverable2 = FactoryGirl.create(:turing_individual_deliverable,:course => @course_fse, :assignment => @assignment1, :creator => @student_sam)
      # Individual deliverable 2
      @deliverable3 = FactoryGirl.create(:test_individual_deliverable,:course => @course_fse, :assignment => @assignment2, :creator => @student_sally)
      # Team deliverable of team Ruby Racer
      @deliverable4 = FactoryGirl.create(:team_ruby_racer_deliverable_1,:course => @course_fse, :team => @team_ruby_racer,:assignment => @assignment1, :creator => @team_member)
      # Individual deliverable 3
      @deliverable5 = FactoryGirl.create(:test_individual_deliverable,:course => @course_fse, :assignment => @assignment2, :creator => @team_member)

      @dav1 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable1, :submitter => @student_sam)
      @dav2 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable2, :submitter => @student_sam)
      @dav3 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable3, :submitter => @student_sally)
      @dav4 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable4, :submitter => @team_member)
      @dav5 =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable5, :submitter => @team_member)

      @options = {:is_my_team => 1, :search_string => "Member"}
      @deliverables = Deliverable.get_deliverables(@course_fse.id, @faculty_frank.id, @options)
      @deliverables.should have(2).items

      @deliverables[0].should == @deliverable4
      @deliverables[1].should == @deliverable5

    end

  end

  context " for a individual deliverable last graded by"   do
    before (:each) do
      @faculty_frank = FactoryGirl.create(:faculty_frank_user)
      @course_fse = FactoryGirl.create(:fse, faculty: [@faculty_frank])
      @student_sam = FactoryGirl.create(:student_sam)
      @assignment = FactoryGirl.create(:assignment_3,:course => @course_fse)
      @deliverable = FactoryGirl.create(:turing_individual_deliverable, :course => @course_fse, :assignment => @assignment, :creator => @student_sam)

      @grade = FactoryGirl.create(:last_graded_visible,:course_id => @course_fse.id,:assignment_id => @assignment.id,:student_id => @student_sam.id)
    end


    it " should get last graded by"  do
      # Get last graded by
      Grade.stub(:get_graded_by).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.creator.id).and_return(@grade)
      @deliverable.get_graded_by.should eq(@faculty_frank)
    end


  end
  context " for a team deliverable last graded by"   do
    before (:each) do
      @faculty_frank = FactoryGirl.create(:faculty_frank_user)
      @course_fse = FactoryGirl.create(:fse, faculty: [@faculty_frank])

      @assignment = FactoryGirl.create(:assignment_3,:course => @course_fse)
      #@deliverable = FactoryGirl.create(:turing_individual_deliverable, :course=>@course_fse, :assignment => @assignment, :creator => @student_sam)
      @deliverable = FactoryGirl.build(:team_deliverable,:course_id => @course_fse.id)
    end


    it " should get last graded by"  do
      # Get last graded by
      @grade = FactoryGirl.create(:grade_invisible, :course_id => @deliverable.course.id, :assignment_id => @deliverable.assignment.id, :last_graded_by => @faculty_frank.id, :student_id =>@deliverable.team.members[0].id)
      Grade.stub(:get_graded_by).with(@deliverable.course.id, @deliverable.assignment.id, @deliverable.team.members[0].id).and_return(@grade)
      @deliverable.get_graded_by.should eq(@faculty_frank)
    end


  end

end


