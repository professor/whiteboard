class CourseUserGrade < ActiveRecord::Base

  validate :grade_in_grading_range

  belongs_to :course
  belongs_to :user

  validates_presence_of :course, :user

  def grade_in_grading_range
    grading_range_grades = self.course.grading_ranges.map {|grading_range| grading_range.grade}
    if !grading_range_grades.include?(self.grade)
      errors.add(:base, "Grades should be a value from [#{grading_range_grades.join(", ")}]")
    end
  end
end