# DeliverableGrade represents a student’s grade for a particular deliverable.
#
# Course -> Assignment -> Deliverable -> DeliverableGrade
#
# A course has many assignments.  Assignments are created by professors, and
# students submit their work to these assignments.  Each student can submit
# one deliverable for an individual assignment.  Similarly, each team can
# submit one deliverable for a team assignment.  Deliverables can be graded,
# and grades are represented through entries in the DeliverableGrade model.
# A deliverable grade is stored as an AES-encrypted string in DB, and it could be a number
# grade or a letter grade.
#
# Courses that are graded on percentages have scores that are out of 100, while
# courses graded on points are graded out of the total points for that
# assignment.
#
# Individual assignments: One deliverable grade for the creator of the
# deliverable
#
# Team assignments: One deliverable grade for each member in the team
#
# Unsubmittable assignments: One deliverable is used as a placeholder for
# each student in the course.  This will be created when the professor grades the
# assignment. Deliverable grades will be created for each student in the course when
# the deliverable is created.  Unsubmittable assignments are always individual assignments.
#
require 'aes'

class DeliverableGrade < ActiveRecord::Base
  include AESCrypt

  belongs_to :user
  belongs_to :deliverable

  validates :user_id, presence: true
  validates :deliverable_id, presence: true
  validates :grade, presence: true
  validate :valid_number_grade, :valid_letter_grade

  before_save :encrypt_grade
  after_find :decrypt_grade

  def grade=(grade)
    write_attribute(:grade, grade.to_s)
  end

  def number_grade
    if is_numeric?
      self.grade.to_f
    else
      previous_grading_range_number = 100.0
      self.deliverable.assignment.course.grading_ranges.each do |grading_range|
        if self.grade == grading_range.grade
          if self.deliverable.assignment.course.grading_criteria == "Points"
            return (previous_grading_range_number / 100) * self.deliverable.assignment.weight
          else
            return previous_grading_range_number
          end
        end
        previous_grading_range_number = (grading_range.minimum - 1).to_f
      end
      return 0
    end
  end

  def link_text
    if self.deliverable.status == 'Graded'
      self.grade
    elsif self.deliverable.status == "Draft"
      "#{self.grade} (#{self.deliverable.status})"
    elsif self.deliverable.attachment_versions.blank?
      "Not Submitted"
    elsif self.deliverable.status == 'Ungraded'
      "Grade"
    else
      "#{self.grade} (#{self.deliverable.status})"
    end
  end

  private

  def valid_number_grade
    if is_numeric?
      if self.grade.to_f < 0
        self.errors.add(:grade, "Grade should be greater or equal to 0")
      end
    end
  end

  def valid_letter_grade
    if !is_numeric?
      valid_letter_grades = self.deliverable.assignment.course.grading_ranges.map {|grading_range| grading_range.grade}

      if !valid_letter_grades.include?(self.grade)
        self.errors.add(:base, "Grade should be a grade in [#{valid_letter_grades.join(", ")}]")
      end
    end
  end

  def is_numeric?
    !!Float(self.grade) rescue false
  end

  def encrypt_grade
    write_attribute(:grade, encrypt(self.grade, iv))
  end

  def decrypt_grade
    write_attribute(:grade, decrypt(self.grade, iv))
  end

  def iv
    Digest::SHA256.hexdigest(self.deliverable.id.to_s + self.user.id.to_s)
  end
end
