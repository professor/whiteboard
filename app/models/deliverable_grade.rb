class DeliverableGrade < ActiveRecord::Base
  belongs_to :user
  belongs_to :deliverable

  validates :user_id, presence: true
  validates :deliverable_id, presence: true
  validates :grade, presence: true
  validate :valid_number_grade, :valid_letter_grade

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
end
