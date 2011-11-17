class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :owner, :foreign_key => :owner_id, :class_name => 'User'

end
