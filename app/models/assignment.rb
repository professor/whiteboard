# Assignment is created by a professor for a course. A student or a team can
# submit one deliverable for each assignment.

class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :deliverables
  has_many :assignment_grades

  accepts_nested_attributes_for :assignment_grades, allow_destroy: true

  validates_presence_of :title
  validates :weight, numericality: { greater_than_or_equal_to: 0 }
  validate :validate_total_weights

  before_validation :check_weight

  default_scope order: "task_number ASC, due_date ASC"

  def submittable?
    self.can_submit
  end

  def formatted_title
    if self.task_number.blank? || (self.course.grading_nomenclature == "Assignments")
      self.title
    else
      "Task #{self.task_number}: #{self.title}"
    end
  end

  def max_score
    if self.course.grading_criteria == "Points"
      "#{self.weight} points"
    else
      "100"
    end
  end

  private

    def validate_due_date
      if self.can_submit?
        if self.due_date.nil?
          self.errors.add(:due_date, "Empty due date")
        else
          if self.due_date <= DateTime.now
            self.errors.add(:due_date, "Due date earlier than now")
          end
        end
      end
    end

    def validate_total_weights
      if self.course.grading_criteria == "Percentage"

        assignments = Assignment.find_all_by_course_id(self.course_id).delete_if {|assignment| assignment.id == self.id}
        sum = 0

        assignments.each do |assignment|
          sum += assignment.weight
        end

        sum += self.weight if !self.weight.blank?

        if sum > 100
         self.errors.add(:weight, "The sum of all assignment weights for this course is greater than 100")
        end
      end
    end

    def check_weight
      if self.weight.blank?
        self.weight = 0
      end
    end
end
