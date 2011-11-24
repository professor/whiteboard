class RegistrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_authorization

  respond_to :html, :json

  layout 'cmu_sv_no_pad'

  def index
    @registrations = Registration.scoped_by_params(params)

    respond_with @registrations
  end

  private

  def require_authorization
    render :text => :unauthorized, :status => :unauthorized unless current_user.permission_level_of(:staff)
  end
end
