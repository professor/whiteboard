require 'spec_helper'

describe Assignment do
  context "assignment fields" do
    before(:each) { @assignment = FactoryGirl.build(:assignment) }
    subject { @assignment }

    it 'should have a title' do
      subject.title = ""
      subject.should_not be_valid
      subject.errors[:title].should_not be_empty
    end

    describe "invalid weight" do
      it 'should not save when weight less than 0' do
        subject.weight = -1
        subject.should_not be_valid
        subject.errors[:weight].should_not be_empty
      end

      it 'should not save when not numerical' do
        subject.weight = "abc"
        subject.should_not be_valid
        subject.errors[:weight].should_not be_empty
      end
    end
  end

  context "course with percentage" do
    before {
      @course = FactoryGirl.create(:course, grading_criteria: 'Percentage')
      @assignment = FactoryGirl.create(:assignment, course: @course)
    }

    context "course with percentage" do
      context "creating and editing assignments that puts the total weight of all assignments of this course greater than 100" do
        it "should not create" do
          another_assignment = @assignment.clone
          another_assignment.weight = 100 - @assignment.weight + 1
          another_assignment.save
          @assignment.errors[:weight].should_not be_empty
        end

        it "should not update" do
          another_assignment = @assignment.clone
          another_assignment.weight = 100 - @assignment.weight
          another_assignment.save
          @assignment.errors[:weight].should be_empty
          another_assignment.weight += 1
          another_assignment.save
          @assignment.errors[:weight].should_not be_empty
        end
      end
    end

    context "course with points" do
      before {
        @course = FactoryGirl.create(:course, grading_criteria: 'Points')
        @assignment = FactoryGirl.create(:assignment, course: @course)
      }

      it "should save at any amount of points" do
        another_assignment = @assignment.clone
        another_assignment.weight = 1000
        another_assignment.save
        @assignment.errors[:weight].should be_empty
      end
    end
  end

  context "find deliverables" do
    it "should find the individual deliverable for a user" do
      @assignment = FactoryGirl.create(:assignment, team_deliverable: false)
      @user = FactoryGirl.create(:student_sally)
      @deliverable = FactoryGirl.create(:deliverable, assignment: @assignment, creator: @user)
      @deliverable_grade = FactoryGirl.create(:deliverable_grade, deliverable: @deliverable, user: @user, grade: 10)
      @deliverable.deliverable_grades = [@deliverable_grade]
      @deliverable.save
      @assignment.find_deliverable_grade(@user).should == @deliverable_grade
    end

    it "should find the team deliverable for a user" do
      @assignment = FactoryGirl.create(:assignment, team_deliverable: true)
      @team = FactoryGirl.create(:team, course: @assignment.course)
      @deliverable = FactoryGirl.create(:deliverable, assignment: @assignment, team: @team)
      @deliverable_grade = FactoryGirl.create(:deliverable_grade, deliverable: @deliverable, user: @team.members.first, grade: 10)
      @deliverable.deliverable_grades = [@deliverable_grade]
      @deliverable.save
      @assignment.find_deliverable_grade(@team.members.first).should == @deliverable_grade
    end
  end
end
