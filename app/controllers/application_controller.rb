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


  # For the academic year 2008-2009, here are the start dates of each semester
  # Fall, 8/25/08 which is cweek 35, (Orientation is 34)
  # Spring, 1/12/09 which is cweek 3, (Gathering is 2)
  # Summer, 5/18/09 which is cweek 21, (Gathering is 20)
  #
  # For the academic year 2009-2010, here are the start dates of each semester
  # Fall, 8/24/09 which is cweek 34, (Orienation is 33)
  # Spring, 1/11/10 which is cweek 2, (Gathering is 1)
  # Summer, 5/17/10 which is cweek 20, (Gathering is 19)
  #
  # Note: to check future dates, use the following code. Date.new(2010, 8, 23).cweek
  #
  # Looking at the calendar, we want current_semester to have these characteristics
  # Spring starts roughly around Christmas and ends 1 week after last day of semester
  # Summer starts 1 week before and end 1 week after semester
  # Fall starts 1 week before and goes to roughly around Christmas
  def self.current_semester
    cweek = Date.today.cweek()
    return "Spring" if cweek < 19 || cweek > 51
    return "Summer" if cweek < 33
    return "Fall"
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

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end


end
