module RestApiMethods
  def self.included(klass)
    klass.class_eval do
      include InstanceMethods

      rescue_from ActiveRecord::RecordNotFound do |exception|
        respond_with_404(exception.message)
      end
    end
  end

  module InstanceMethods
    def find_course
      @course ||= Course.find_by_id!(params[:course_id])
    end

    def respond_with_404(message=nil)
      render :json => { :error => 'Resource not found', :message => message}, :status => 404
    end
  end
end
