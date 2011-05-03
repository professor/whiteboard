# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

#  include AuthenticatedSystem
  include ExceptionNotifiable

  helper_method :current_user_session, :current_user


  def development?
    @is_development ||=(ENV['RAILS_ENV']=='development')
  end
  
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5e9d164f3052749a36db7a972c72915a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password


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

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    #Temporary method until we merge person and user
    def current_person
      if current_user
        Person.find(current_user.id)
      else
        nil
      end
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"

#        redirect_to new_user_session_url
        redirect_to login_google_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
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

    def editable_or_redirect(object, url)
        unless object.editable(current_user)
          flash[:error] = t(:not_editable)
#          redirect_back_or_default(url)
          redirect_to(url)
          return false
        end
      return true
    end



  
end
