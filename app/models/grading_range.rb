class GradingRange < ActiveRecord::Base
  belongs_to :course
  validates :minimum_value, numericality: { less_than_or_equal_to: 100, greater_than_or_equal_to: 0 }

  def self.possible_grades
    ["A+",
     "A",
     "A-",
     "B+",
     "B",
     "B-",
     "C+",
     "C",
     "C-",
     "D+",
     "D",
     "D-",
     "F"]
  end
end
