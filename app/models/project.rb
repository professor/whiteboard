class Project < ActiveRecord::Base
  belongs_to :project_type
  belongs_to :course
  
  def before_create
       self.is_closed = 0  #false
  end

end
