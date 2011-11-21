class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :owner, :foreign_key => :owner_id, :class_name => 'Person'

  validates_presence_of :name, :present_date, :task_number
end
