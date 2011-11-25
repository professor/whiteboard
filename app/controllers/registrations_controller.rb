class RegistrationsController < ApplicationController
  include RestApiMethods

  before_filter :authenticate_user!
  before_filter :require_authorization!

  respond_to :html, :json

  layout 'cmu_sv_no_pad'

  def index
    @registrations = Registration.scoped_by_params(params)

    respond_with @registrations
  end

  # Get #bulk_import
  def bulk_import
    
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
end
