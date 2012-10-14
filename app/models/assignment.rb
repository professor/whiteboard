# Assignment is the task/deliverable on which the professor grades for students.
#
# Professor can create an assignment on course assignments index page by clicking the "New Assignment" link. 
# He can group assignments by task number, i.e., there could be multiple assignments in one task. 
# The assignment is ordered based on task number as well as assignment order. 
# The assignment order is automatically generated when professor created the assignment.  
# For each assignment, professor should give a maximum score for each assignment.  
# The professor could also indicate whether the assignment required student submission. 
# 
# Generally, a course has many assignments, and each assignments contains many student grades(grade_books)
#
 
class Assignment < ActiveRecord::Base
  attr_accessible :name, :course_id, :maximum_score, :is_team_deliverable, :due_date, :assignment_order, :task_number, :is_submittable
  validates :maximum_score , :presence=>true,  :numericality =>{ :greater_than_or_equal_to=>0}
  validates_presence_of :course_id  , :task_number

  belongs_to :course

  has_many :grade_books

  acts_as_list :column=>"assignment_order", :scope => [:course_id, :task_number]


  default_scope :order => 'task_number ASC, assignment_order ASC'

end
