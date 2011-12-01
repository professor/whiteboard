class RegistrationsController < ApplicationController
  include RestApiMethods

  before_filter :authenticate_user!
  before_filter :require_authorization!
  before_filter :find_course

  respond_to :html, :json

  layout 'cmu_sv_no_pad'

  def index
    @registrations = Registration.scoped_by_params(params)

    respond_with @registrations
  end

  # Get #bulk_import
  def bulk_import
  end

  # Post #bulk_upload
  def bulk_upload
    uploaded_io = params[:registrations_file]
    upload_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
    File.open(upload_path, 'wb') { |file| file.write(uploaded_io.read) }

    case uploaded_io.content_type
      when "text/rtf"
        Registration.process_import( HubStudentImporter.import_rtf(upload_path) )
        message_hash = { :notice => "Success!" }
      when "text/html"
        Registration.process_import( HubStudentImporter.import_html(upload_path) )
        message_hash = { :notice => "Success!" }
      else
        File.delete(upload_path)
        message_hash = { :notice => "Unsupported data file type" }
    end

    redirect_to :bulk_import_registrations, message_hash
  end
  
  # Placeholder object for query regarding students not assigned to teams. We'll need to fix this.
  def students_not_assigned_to_teams
	@people = @course.registered_students_not_in_team
  end
  
    # GET /courses/:id/registrations/find_unregistered_students_for_course
  def find_unregistered_students_for_course
    @nonregistered_users = @course.unregistered_students_on_team
  end

  # def new
  #   
  # end

  # def create
  #   
  # end

  # def update
  #   
  # end

  # def edit
  #   
  # end

  # def destroy
  #   
  # end

  # def show
  #   
  # end

  private

  def require_authorization!
    render :nothing => true, :status => :unauthorized unless current_user.permission_level_of(:staff)
  end
  
  def find_course
     @course = Course.find(params[:course_id]) if params[:course_id].present?
  end
end
