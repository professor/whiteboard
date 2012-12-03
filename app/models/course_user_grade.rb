# CourseUserGrade represents a student’s final letter grade for a course.
#
# We don’t store a student’s earned grade, which is calculated by summing all
# the student’s deliverable grades based on the course’s grading criteria
# (e.g. point-based or percentage-based); the earned grade is calculated on
# demand.  However, we store the student’s final grade so that the professor
# can adjust it if necessary.  The grade is AES-encrypted.
#
require 'aes'

class CourseUserGrade < ActiveRecord::Base
  include AESCrypt

  validate :grade_in_grading_range

  belongs_to :course
  belongs_to :user

  validates_presence_of :course, :user

  before_save :encrypt_grade
  after_save :decrypt_grade
  after_find :decrypt_grade

  def self.notify_final_grade(course, user)
    final_grade = self.find_or_initialize_by_course_id_and_user_id(course.id, user.id)

    if final_grade.new_record?
      earned_score = course.get_user_deliverable_grades(user).to_a.sum(&:number_grade)
      final_grade.grade = course.number_to_letter_grade(earned_score)
      final_grade.notified_at = Time.now
      final_grade.save
    else
      final_grade.update_attributes(notified_at: Time.now)
    end

    CourseMailer.notify_final_grade(course, user).deliver
  end

  def grade_in_grading_range
    grading_range_grades = self.course.grading_ranges.map {|grading_range| grading_range.grade}
    if !grading_range_grades.include?(self.grade)
      errors.add(:base, "Grades should be a value from [#{grading_range_grades.join(", ")}]")
    end
  end

  private

  def encrypt_grade
    self.grade = encrypt(self.grade, iv)
  end

  def decrypt_grade
    self.grade = decrypt(self.grade, iv)
  end

  def iv
    Digest::SHA256.hexdigest(self.course.id.to_s + self.user.id.to_s)
  end
end
