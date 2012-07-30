# Person is a versioned model representing user data. As described in the README,
# the Person model and the User model both represent the same database table.
#
# == Related classes
# {Person Controller}[link:classes/PeopleController.html]
#
# {User}[link:classes/User.html]
#
class Person < User
  set_table_name "users"


#  def to_param
#    if twiki_name.blank?
#      id.to_s
#    else
#      twiki_name
#    end
#  end






  #
  # Creates a Google Apps for University account for the user. For legacy reasons,
  # the accounts are with the domain west.cmu.edu even though the preferred way
  # of talking about the account is with the domain sv.cmu.edu
  #
  # Input is a password
  # If this fails, it returns an error message as a string
  #
  def create_google_email(password)
    return "Empty email address" if self.email.blank?
    logger.debug("Attempting to create google email account for " + self.email)
    (username, domain) = switch_sv_to_west(self.email).split('@')

    if domain != GOOGLE_DOMAIN
      logger.debug("Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN)
      return "Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN + ")"
    end

    begin
      user = google_apps_connection.create_user(username,
                                                self.first_name,
                                                self.last_name,
                                                password)
    rescue GDataError => e
      #error code : 1300, invalid input : Andrew.Carngie, reason : EntityExists
      return pretty_print_google_error(e)
    end
    self.google_created = Time.now()
    self.save
    return(user)
  end

  #
  # Creates a twiki account for the user
  #
  # You may need to modify mechanize as seen here
  # http://github.com/eric/mechanize/commit/7fd877c60cbb3855652c390c980df1dedfaed820
  def create_twiki_account
    require 'mechanize'
    agent = Mechanize.new
    agent.basic_auth(TWIKI_USERNAME, TWIKI_PASSWORD)
    agent.get(TWIKI_URL + '/do/view/TWiki/TWikiRegistration') do |page|
      registration_result = page.form_with(:action => '/do/register/Main/WebHome') do |registration|
        registration.Twk1FirstName = self.first_name
        registration.Twk1LastName = self.last_name
        registration.Twk1WikiName = self.twiki_name
        registration.Twk1Email = self.email
        registration.Twk0Password = 'just4now'
        registration.Twk0Confirm = 'just4now'
        registration.Twk1Country = 'USA'
        #      registration.action = 'register'
        #      registration.topic = 'TWikiRegistration'
        #      registration.rx = '%BLACKLISTPLUGIN{ action=\"magic\" }%'
      end.submit
      #   #<WWW::Mechanize::Page::Link "AndrewCarnegie" "/do/view/Main/AndrewCarnegie">
      link = registration_result.link_with(:text => self.twiki_name)
      if link.nil?
        #the user probably already exists
        pp registration_result
        return false
      end
      self.twiki_created = Time.now()
      self.save
      return true
    end


  end

  def reset_twiki_password
    require 'mechanize'
    agent = Mechanize.new
    agent.basic_auth(TWIKI_USERNAME, TWIKI_PASSWORD)
    agent.get(TWIKI_URL + '/do/view/TWiki/ResetPassword') do |page|
      reset_result_page = page.form_with(:action => '/do/resetpasswd/Main/WebHome') do |reset_page|
        reset_page.LoginName = self.twiki_name
      end.submit

      return false if reset_result_page.parser.css('.patternTopic h3').text == " Password reset failed "
      return true if reset_result_page.link_with(:text => 'change password')

      return true
    end
  end

  def create_yammer_account
    #See lib/yammer.rb for code that would create the user account.
    #We can't use the yammer API until we upgrade the service

    #The most simple way here is to invite the user to register
    #Note that yammer requires https://www.yammer.com/
    require 'mechanize'
    agent = Mechanize.new
    agent.get('https://www.yammer.com/') do |page|
      result_page = page.form_with(:action => '/users') do |invite_page|
        invite_page['user[email]'] = self.email
      end.submit
    end

    self.yammer_created = Time.now()
    self.save
    return true
  end


#   def create_adobe_connect
#     require 'mechanize'
#     agent = Mechanize.new
#     agent.get(ADOBE_CONNECT_NEW_USER_URL) do |login_page|
#       login_page.login = ADOBE_CONNECT_USERNAME
#       login_page.password = ADOBE_CONNECT_PASSWORD
#       reset_result_page = page.form_with(:action => '/do/resetpasswd/Main/WebHome') do |reset_page|
#           reset_page.LoginName = self.twiki_name
#       end.submit
#
#       return false if reset_result_page.parser.css('.patternTopic h3').text == " Password reset failed "
#       return true if reset_result_page.link_with(:text => 'change password')
#
#       return true
#     end
#   end




end
