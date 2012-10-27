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
      it 'should not save when weight less or equal to 0' do
        subject.weight = 0
        subject.should_not be_valid
        subject.errors[:weight].should_not be_empty
      end

      it 'should not save when not numerical' do
        subject.weight = "abc"
        subject.should_not be_valid
        subject.errors[:weight].should_not be_empty
      end
    end

    context 'when the student can submit' do
      before(:each) { subject.can_submit = true }
      it 'should have a valid due date' do
        subject.due_date = DateTime.now
        subject.should_not be_valid
        subject.errors[:due_date].should_not be_empty
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
end
