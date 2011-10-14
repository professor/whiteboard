# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  # render new.rhtml
  def new
  end

  def new_dev_env
  end

  def create_webiso
    create
  end

  def create
    logout_keeping_session!
    webiso_error_msg = ""


    if request.env['HTTP_AUTHORIZATION'].nil?
      login_name = params[:login]
      user = User.authenticate(params[:login], params[:password])
    else
      login_name = request.env['HTTP_AUTHORIZATION'].split(' ')[1].unpack("m").to_s.split(':')[0]
#      user = Person.find(:first, :conditions => ["webiso_account = ?", login_name])
      user = User.find(:first, :conditions => ["webiso_account = ?", login_name])
      webiso_error_msg = ": No user associated with " + login_name if !user
      logger.error webiso_error_msg if webiso_error_msg
      params[:remember_me] = "1"

    end

    if user
      logger.info 'login of user ' + login_name unless login_name.nil?
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      note_failed_signin
      @login = params[:login]
      @remember_me = params[:remember_me]
      flash.now[:error] = "Authentication failed" + webiso_error_msg
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
