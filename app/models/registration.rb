class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :person

  scope :for_course, lambda { |course_id|
    where(:course_id => course_id) unless course_id.nil?
  }

  def self.scoped_by_params(params={})
    self.for_course(params[:course_id])
  end
end
