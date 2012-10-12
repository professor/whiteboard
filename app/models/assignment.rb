class Assignment < ActiveRecord::Base
  attr_accessible :name, :course_id, :maximum_score, :is_team_deliverable, :due_date, :assignment_order, :task_number, :is_submittable
  validates :maximum_score , :presence=>true,  :numericality =>{ :greater_than_or_equal_to=>0}
  validates_presence_of :course_id

  belongs_to :course

  has_many :grade_books

  acts_as_list :column=>"assignment_order", :scope => [:course_id, :task_number]


  default_scope :order => 'task_number ASC, assignment_order ASC'


  def self.reposition(ids)
    #if database is mysql
    #    update_all(
    #      ['position = FIND_IN_SET(id, ?)', ids.join(',')],
    #      { :id => ids }
    #    )
    update_all(["position = STRPOS(?, ','||id||',')", ",#{ids.join(',')},"], {:id => ids})
  end


end
