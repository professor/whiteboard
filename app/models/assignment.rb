class Assignment < ActiveRecord::Base
  belongs_to :course

  validates_presence_of :title
  validates :weight, numericality: { greater_than: 0, less_than_or_equal_to: 100 }, presence: true
  validate :validate_due_date, :validate_total_weights

  default_scope order: "task_number ASC, created_at ASC"

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
      assignments = Assignment.find_all_by_course_id(self.course_id)
      sum = 0

      assignments.each do |assignment|
        sum += assignment.weight
      end

      if sum + self.weight > 100
        self.errors.add(:weight, "The sum of all assignment weights for this course is greater than 100")
      end
    end
end
