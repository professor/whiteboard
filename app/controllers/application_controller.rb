class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  helper_method :current_user

  before_filter :make_available_for_exception_notification

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5e9d164f3052749a36db7a972c72915a'

  # Return true if the user agent is a bot.
  def robot?
    bot = /(Baidu|bot|Google|SiteUptime|Slurp|WordPress|ZIBB|ZyBorg)/i
    request.user_agent =~ bot
  end

  private
  def get_http_referer
    if request.env["HTTP_REFERER"].nil? then
      return ""
    else
      return request.env["HTTP_REFERER"].gsub('http:', 'https:')
    end
  end

  def get_http_host
    return request.env["HTTP_X_FORWARDED_HOST"] || request.env["HTTP_HOST"]
  end

  def get_twiki_http_referer
    if request.env["HTTP_REFERER"].nil? then
      return ""
    else
      url = request.env["HTTP_REFERER"].gsub('info.west.cmu.edu', 'info.sv.cmu.edu').gsub('https:', 'http:')
      url_no_query_string = url.split('?')[0]
      url_no_anchors = url_no_query_string.split('#')[0]
      return url_no_anchors
    end
  end

  #Temporary method until we merge person and user
  def current_person
    if current_user
      Person.find(current_user.id)
    else
      nil
    end
  end

##  In development, if you want to pretend to be a different user, you can set it easily here
  #def current_user
   # User.find_by_id 1 #Cecile
    #User.last
 # end

  def authenticate_user!
    if !current_user
      # This should work, but session is lost. See https://github.com/plataformatec/devise/issues/1357
      # session[:return_to] = request.fullpath
      redirect_to user_omniauth_authorize_path(:google_apps, :origin => request.fullpath)
    end
  end

  def user_profile_status_check
    if !current_user.profile_updated?
      if current_user.should_be_redirected?
        redirect_to root_path
      else
        #popup a box
      end
    end
  end

  #Return to the page the user was trying to access after a login
  def after_sign_in_path_for(resource)
    # This should work, but session is lost. See https://github.com/plataformatec/devise/issues/1357
    # return_to = session[:return_to]
    # session[:return_to] = nil
    return_to = request.env['omniauth.origin']
    stored_location_for(resource) || return_to || root_path
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def store_previous_location
    session[:return_to] = request.env["HTTP_REFERER"]
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # level = :admin, :staff, :student
  def has_permissions_or_redirect(level, url)
    unless current_user.permission_level_of(level)
      flash[:error] = t(:no_permission)
      #          redirect_back_or_default(url)
      redirect_to(url)
      return false
    end
    return true
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message #We can remove this line when we upgrade to Rails 3.2
    redirect_to root_url, :error => exception.message
  end

  # Now in locales
  #def american_date
  #  '%m/%d/%Y'
  #end

  protected
  def make_available_for_exception_notification
    request.env["exception_notifier.exception_data"] = {
        :current_user => current_user
    }
  end

end
