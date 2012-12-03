# GradingRange is set by a professor for a course
#
# It is a mapping between letter and number grades.

class GradingRange < ActiveRecord::Base
  attr_accessible :grade, :minimum, :course_id
  belongs_to :course
  validates :minimum, numericality: { greater_than_or_equal_to: 0 }

  def self.possible_grades
    {
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
     "F" => 0}
  end
end
