class Project < ActiveRecord::Base
  belongs_to :project_type
  belongs_to :course

  before_create :close_project

  protected
  def close_project
    self.is_closed = 0 #false
  end

end
