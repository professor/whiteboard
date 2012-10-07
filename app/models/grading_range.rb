class GradingRange < ActiveRecord::Base
  belongs_to :course
  validates :minimum, numericality: { less_than_or_equal_to: 100, greater_than_or_equal_to: 0 }

  def self.possible_grades
    {"A+" => 98,
     "A" => 94,
     "A-" => 90,
     "B+" => 88,
     "B" => 84,
     "B-" => 80,
     "C+" => 78,
     "C" => 74,
     "C-" => 70,
     "D+" => 68,
     "D" => 64,
     "D-" => 60,
     "F" => 50}
  end
end
