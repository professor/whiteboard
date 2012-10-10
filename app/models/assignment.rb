class Assignment < ActiveRecord::Base
  belongs_to :course

  validates_presence_of :title
  validates :weight,    numericality: { greater_than_or_equal_to: 0 }, presence: true
  validate :validate_due_date

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
end
