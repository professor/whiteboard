require 'spec_helper'

describe CourseUserGrade do
  it "should have a grade that is present in the grading range" do
    course_user_grade = FactoryGirl.build(:course_user_grade)
    grading_range_grades = course_user_grade.course.grading_ranges.select {|grading_range| grading_range.grade}
    grading_range_grades.each do |grade|
      course_user_grade.grade = grade
      course_user_grade.should be_valid
    end
  end

  it "should have a grade that is present in the grading range" do
    course_user_grade = FactoryGirl.build(:course_user_grade, grade: "AAA")
    course_user_grade.should_not be_valid
  end
end
