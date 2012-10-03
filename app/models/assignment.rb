class Assignment < ActiveRecord::Base
  attr_accessible :name, :course_id, :maximum_score, :is_team_deliverable, :due_date, :assignment_order, :task_number
  validates :maximum_score , :presence=>true,  :numericality =>{ :greater_than_or_equal_to=>0}
  validates_presence_of :course_id  ,:assignment_order, :task_number

  belongs_to :course

end
