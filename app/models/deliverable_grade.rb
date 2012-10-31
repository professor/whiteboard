class DeliverableGrade < ActiveRecord::Base
  belongs_to :user
  belongs_to :deliverable

  validates :user_id, presence: true
  validates :deliverable_id, presence: true
  validates :grade, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validate :grade_upper_limit

  def max_score
    if self.deliverable.assignment.course.grading_criteria == "Points"
      "#{self.deliverable.assignment.weight} points"
    else
      "#{self.deliverable.assignment.weight}%"
    end
  end

  private
    def grade_upper_limit
      if !self.grade.blank? && self.grade > self.deliverable.assignment.weight
        self.errors.add(:grade, "Grade can't be over #{self.max_score} for this assignment")
      end
    end
end
