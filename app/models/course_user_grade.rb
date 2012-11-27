# CourseUserGrade represents a student’s final letter grade for a course.
#
# We don’t store a student’s earned grade, which is calculated by summing all
# the student’s deliverable grades based on the course’s grading criteria
# (e.g. point-based or percentage-based); the earned grade is calculated on
# demand.  However, we store the student’s final grade so that the professor
# can adjust it if necessary.
#
require 'aes'

class CourseUserGrade < ActiveRecord::Base
  include AESCrypt

  validate :grade_in_grading_range

  belongs_to :course
  belongs_to :user

  validates_presence_of :course, :user

  before_save :encrypt_grade
  after_find :decrypt_grade

  def grade_in_grading_range
    grading_range_grades = self.course.grading_ranges.map {|grading_range| grading_range.grade}
    if !grading_range_grades.include?(self.grade)
      errors.add(:base, "Grades should be a value from [#{grading_range_grades.join(", ")}]")
    end
  end

  private

  def encrypt_grade
    self.grade = encrypt(self.grade)
  end

  def decrypt_grade
    self.grade = decrypt(self.grade)
  end
end
