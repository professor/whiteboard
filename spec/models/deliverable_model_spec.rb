require 'spec_helper'

describe Deliverable do

  it 'can be created' do
    lambda {
      FactoryGirl.create(:deliverable)
    }.should change(Deliverable, :count).by(1)
  end

  context "is not valid" do

    [:creator, :assignment].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end

    context "when a duplicate deliverable for the same course, task and owner" do
      [:team_deliverable, :individual_deliverable].each do |symbol|
        it "for a team/individual deliverable" do
          original = FactoryGirl.build(symbol)
          original.stub(:update_team)
          original.save
          duplicate = Deliverable.new()
          duplicate.stub(:update_team)
          duplicate.creator_id = original.creator_id
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

  context "assignment" do
    before { @deliverable = FactoryGirl.build(:team_deliverable) }
    subject { @deliverable }

    it { should be_valid }

    it "should be invalid without an assignment" do
      @deliverable.assignment = nil
      @deliverable.should_not be_valid
    end
  end

  context 'filtering' do
    before {
      @course1 = FactoryGirl.create(:course, name: "Course 1", semester: 'Fall', year: 2012)
      @course2 = FactoryGirl.create(:course, name: "Course 2", semester: 'Spring', year: 2012)
      @student1 = FactoryGirl.create(:student_sally)
      @student2 = FactoryGirl.create(:student_sam)

      @assign1 = FactoryGirl.create(:assignment, course: @course1, title: "Assignment 1")
      @assign2 = FactoryGirl.create(:assignment, course: @course2, title: "Assignment 2")
      @assign3 = FactoryGirl.create(:assignment, course: @course1, title: "Assignment 3")
      @assign4 = FactoryGirl.create(:assignment, course: @course2, title: "Assignment 4")

      @deliverable1 = FactoryGirl.create(:deliverable, assignment: @assign1, creator: @student1)
      @deliverable2 = FactoryGirl.create(:deliverable, assignment: @assign2, creator: @student2)
      @deliverable3 = FactoryGirl.create(:deliverable, assignment: @assign3, creator: @student1)
      @deliverable4 = FactoryGirl.create(:deliverable, assignment: @assign4, creator: @student2)
    }

    it "should return the correct number of deliverables" do
      filter_params = {semester_year: 'Spring-2012', course_id: @course2.id, assignment_id: '', submitted_by: '', status: 'Ungraded'}
      deliverables = Deliverable.filter(filter_params)
      deliverables.size.should == 2
      deliverables.should include(@deliverable2, @deliverable4)

      @deliverable4.status = "Graded"
      @deliverable4.save
      deliverables = Deliverable.filter(filter_params)
      deliverables.size.should == 1
      deliverables.should include(@deliverable2)
    end
  end
end


