class PasswordResetsController < ApplicationController
  layout 'cmu_sv'

  # Display new password reset page
  def index
    redirect_to new_password_reset_path
  end

  # Create new password reset request
  def create
    @user = User.find_by_email(params[:cmu_email])
    @active_directory_services = ActiveDirectory.new

    if verify_recaptcha(:model => @user, :attribute => "verification code")
      if @user && @user.personal_email == params[:personal_email]
        @active_directory_services.send_password_reset_token(@user)
      else
        flash[:error] = "Your email entries did not match our records. Please try again or contact help@sv.cmu.edu"
        redirect_to new_password_reset_path and return
      end
      redirect_to root_url, :notice => "Password reset instructions have been sent to #{@user.personal_email}."
    else
      flash[:error] = "Verification code is wrong"
      redirect_to new_password_reset_path
    end
  end

  # Display edit form with password reset token link
  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to new_password_reset_path, :flash => {:error => "Password reset link is invalid."}
  end

  # Do actual password reset
  def update
    @user = User.find_by_password_reset_token!(params[:id])
    @active_directory_services = ActiveDirectory.new
    respond_to do |format|
      if @user.password_reset_sent_at > 2.hours.ago
        if params[:new_password]
          if @active_directory_services.reset_password(@user, params[:new_password]) == "Success"
            flash[:notice] = "Password has been reset!"
            format.html { redirect_to root_url }
          else
            flash[:error]="Password reset was unsuccessful. Read the instructions below or contact help@sv.cmu.edu"
            redirect_to edit_password_reset_path and return
          end
        else
          flash[:error]="Invalid new password parameter. Contact help@sv.cmu.edu"
          redirect_to edit_password_reset_path and return
        end
      else
        flash[:error] = "Password reset link has expired."
        format.html { redirect_to new_password_reset_path }
      end
    end
  end
end
