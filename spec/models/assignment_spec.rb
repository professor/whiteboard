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

  context "creating placeholder deliverables for unsbumittable assignments" do
    before {
      @ppm = FactoryGirl.create(:ppm_current_semester)
      #@faculty_assignment = FactoryGirl.create(:faculty_assignment)
      #@assignment = FactoryGirl.create(:assignment, team_deliverable: true, can_submit: false, course: @faculty_assignment.course)
      #@student1 = FactoryGirl.create(:student)
      #@student2 = FactoryGirl.create(:student)
      #@student1.registered_courses = [@assignment.course]
      #@student2.registered_courses = [@assignment.course]
      #@student1.save
      #@student2.save
      #@assignment.create_placeholder_deliverable(@faculty_assignment.user)
      @unsubmittable_assignment = @ppm.assignments.find_by_can_submit(false)
    }

    it "should create a deliverable grade for each student in the course" do
      students = @ppm.all_students.values

      expect {
        @unsubmittable_assignment.create_placeholder_deliverables
      }.to change(Deliverable, :count).by(students.size)

      deliverables = @unsubmittable_assignment.reload.deliverables
      deliverable_student_ids = deliverables.map { |deliverable| deliverable.creator_id }

      students.each do |student|
        deliverable_student_ids.should include(student.id)
      end
    end

    it "should account for students who register out of the class" do
      @unsubmittable_assignment.create_placeholder_deliverables
      @student1.registered_courses = []
      @student1.save
      @assignment.reload

      expect {
        @@unsubmittable_assignment.create_placeholder_deliverables
      }.to change(Deliverable, :count).by(-1)
    end

    it "should account for students who register into the class" do
      @unsubmittable_assignment.create_placeholder_deliverables
      @student3 = FactoryGirl.create(:student)
      @student3.registered_courses = [@assignment.course]
      @student3.save
      @assignment.reload

      expect {
        @unsubmittable_assignment.create_placeholder_deliverables
      }.to change(Deliverable, :count).by(1)
    end
  end

  context "testing with rspec" do
    it "blah" do
      assignment = FactoryGirl.create(:ppm_assignment_7)
    end
  end
end
