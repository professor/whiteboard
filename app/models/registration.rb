class Registration < ActiveRecord::Base
  belongs_to :course
  belongs_to :person

  scope :for_course, lambda { |course_id|
    where(:course_id => course_id) unless course_id.nil?
  }

  def self.scoped_by_params(params={})
    # Raise record not found and let controller handle
    # response if provided course_id is invalid
    course = Course.find_by_id!(params[:course_id]) if params[:course_id].present?

    self.for_course(params[:course_id])
  end
end
