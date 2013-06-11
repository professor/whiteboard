class PasswordResetsController < ApplicationController
  layout 'cmu_sv'

  # Display new password reset page
  def index
    redirect_to new_password_reset_path
  end

  # Create new password reset request
  def create
    @user = User.find_by_email(params[:primaryEmail])
    @active_directory_services = ActiveDirectoryServices.new

    if verify_recaptcha(:model=>@user, :attribute=>"verification code")
      if @user && @user.personal_email == params[:personalEmail]
        @active_directory_services.send_password_reset_token(@user)
      else
        flash[:error] = "Your entries do not match records"
        redirect_to new_password_reset_path and return
      end
      redirect_to root_url, :notice => "Password reset instructions have been sent to your secondary email account."
    else
      flash[:error] = "Verification code is wrong"
      redirect_to new_password_reset_path
    end
  end

  # Display edit form with password reset token link
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to new_password_reset_path, :flash => { :error => "Password reset link has expired." }
  end

  # Do actual password reset
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    @active_directory_services = ActiveDirectoryServices.new
    respond_to do |format|
      if @user.password_reset_sent_at>2.hours.ago
        if params[:newPassword]
            if @active_directory_services.reset_password(@user, params[:newPassword]) == "Success"
              flash[:notice] = "Password has been reset!"
              format.html {redirect_to root_url}
            else
              flash[:error]="Password reset was unsuccessful."
              redirect_to edit_password_reset_path and return
            end
        end
      else
        flash[:error] = "Password reset link has expired."
        format.html {redirect_to new_password_reset_path}
      end
    end
  end
end
