require 'spec_helper'

describe AssignmentGrade do
  context "assignment grade fields" do
    before {
      @student = FactoryGirl.create(:student_sally)
      @course = FactoryGirl.create(:course, grading_criteria: "Points")
      @assignment = FactoryGirl.create(:assignment, weight: 20, course: @course)
      @assignment_grade = FactoryGirl.build(:assignment_grade, assignment: @assignment, user: @student)
    }

    it "should save" do
      @assignment_grade.given_grade = @assignment.weight - 1
      expect { @assignment_grade.save }.to change(AssignmentGrade, :count).by(1)
    end

    it "should not save when grade is less than 0" do
      @assignment_grade.given_grade = -1
      expect { @assignment_grade.save }.to_not change(AssignmentGrade, :count)
      @assignment_grade.errors.should include(:grade)
    end

    it "should save when given a letter grade in the course's grading range" do
      @assignment_grade.given_grade = "A"
      expect { @assignment_grade.save }.to change(AssignmentGrade, :count).by(1)
    end

    it "should not save when given a letter grade not in the course's grading range" do
      @assignment_grade.given_grade = "A+"
      expect { @assignment_grade.save }.to_not change(AssignmentGrade, :count)
    end

    #it "should convert a letter grade to a number grade in a point course" do
    #  previous_grading_range_number = 100.0
    #  @assignment.course.grading_ranges.each do |grading_range|
    #    @deliverable_grade.grade = grading_range.grade
    #    @deliverable_grade.number_grade.should == (previous_grading_range_number / 100) * @assignment.weight
    #    previous_grading_range_number = (grading_range.minimum - 1).to_f
    #  end
    #end
    #
    #it "should convert a letter grade to a number grade in a percentage course" do
    #  ppm_course = FactoryGirl.create(:ppm_current_semester)
    #  first_assignment = ppm_course.assignments.first
    #  first_deliverable_grade = ppm_course.assignments.first.deliverables.first.deliverable_grades.first
    #  previous_grading_range_number = 100
    #  ppm_course.grading_ranges.each do |grading_range|
    #    first_deliverable_grade.grade = grading_range.grade
    #    first_deliverable_grade.number_grade.should == previous_grading_range_number
    #    previous_grading_range_number = grading_range.minimum - 1
    #  end
    #end
  end
end