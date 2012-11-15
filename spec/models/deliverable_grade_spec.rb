require 'spec_helper'

describe DeliverableGrade do
  context "deliverable grade fields" do
    before {
      @student = FactoryGirl.create(:student_sally)
      @course = FactoryGirl.create(:course, grading_criteria: "Points")
      @assignment = FactoryGirl.create(:assignment, weight: 20, course: @course)
      @deliverable = FactoryGirl.create(:deliverable, creator: @student)
      @deliverable_grade = FactoryGirl.build(:deliverable_grade, deliverable: @deliverable, user: @student)
    }

    it "should save" do
      @deliverable_grade.grade = @assignment.weight - 1
      expect { @deliverable_grade.save }.to change(DeliverableGrade, :count).by(1)
    end

    it "should not save when grade is less than 0" do
      @deliverable_grade.grade = -1
      expect { @deliverable_grade.save }.to_not change(DeliverableGrade, :count)
      @deliverable_grade.errors.should include(:grade)
    end

    it "should save when given a letter grade in the course's grading range" do
      @deliverable_grade.grade = "A"
      expect { @deliverable_grade.save }.to change(DeliverableGrade, :count).by(1)
    end

    it "should not save when given a letter grade not in the course's grading range" do
      @deliverable_grade.grade = "A+"
      expect { @deliverable_grade.save }.to_not change(DeliverableGrade, :count)
    end

    it "should convert a letter grade to a number grade in a point course" do
      previous_grading_range_number = 100.0
      @assignment.course.grading_ranges.each do |grading_range|
        @deliverable_grade.grade = grading_range.grade
        @deliverable_grade.number_grade.should == (previous_grading_range_number / 100) * @assignment.weight
        previous_grading_range_number = (grading_range.minimum - 1).to_f
      end
    end

    it "should convert a letter grade to a number grade in a percentage course" do
      ppm_course = FactoryGirl.create(:ppm_current_semester)
      first_assignment = ppm_course.assignments.first
      first_deliverable_grade = ppm_course.assignments.first.deliverables.first.deliverable_grades.first
      previous_grading_range_number = 100
      ppm_course.grading_ranges.each do |grading_range|
        first_deliverable_grade.grade = grading_range.grade
        first_deliverable_grade.number_grade.should == previous_grading_range_number
        previous_grading_range_number = grading_range.minimum - 1
      end
    end
  end
end