# Person is a versioned model representing user data. As described in the README,
# the Person model and the User model both represent the same database table.
#
# == Related classes
# {Person Controller}[link:classes/PeopleController.html]
#
# {User}[link:classes/User.html]
#
class Person < ActiveRecord::Base
  set_table_name "users"
  #We version the user table unless the Scotty Dog effort log warning email caused this save to happen
  acts_as_versioned  :table_name => 'user_versions', :if => Proc.new { |user| (user.effort_log_warning_email.nil? || user.effort_log_warning_email <= 1.minute.ago ||
   user.sponsored_project_effort_last_emailed.nil? || user.sponsored_project_effort_last_emailed <= 1.minute.ago  ) }

#  acts_as_authentic

#  enabling this currently breaks adding a team member to a team. Not sure why Authlogic would cause that to happen  
  acts_as_authentic do |c|
    c.validate_login_field = false #We are using openid, no login field required
    c.require_password_confirmation = false
    c.validate_password_field = false
  end
# This next method is a dummy method while Authlogic is turned off for Person
#  def save_without_session_maintenance
#    self.save
#  end

  has_and_belongs_to_many :teams, :join_table=>"teams_people"
  has_and_belongs_to_many :papers, :join_table=>"papers_people"

  belongs_to :strength1, :class_name => "StrengthTheme", :foreign_key => "strength1_id"
  belongs_to :strength2, :class_name => "StrengthTheme", :foreign_key => "strength2_id"
  belongs_to :strength3, :class_name => "StrengthTheme", :foreign_key => "strength3_id"
  belongs_to :strength4, :class_name => "StrengthTheme", :foreign_key => "strength4_id"
  belongs_to :strength5, :class_name => "StrengthTheme", :foreign_key => "strength5_id"



  validates_uniqueness_of   :login,    :case_sensitive => false, :allow_nil => true
  validates_uniqueness_of   :webiso_account,    :case_sensitive => false, :allow_nil => true

#  def to_param
#    if twiki_name.blank?
#      id.to_s
#    else
#      twiki_name
#    end
#  end

  named_scope :staff, :conditions => {:is_staff => true, :is_active => true}, :order => 'human_name ASC'
  named_scope :teachers, :conditions => {:is_teacher => true, :is_active => true}, :order => 'human_name ASC'


    def before_validation
      self.webiso_account = Time.now.to_f.to_s if self.webiso_account.blank?
    end

    def before_save 
      # We populate some reasonable defaults, but this can be overridden in the database
      self.human_name = self.first_name + " " + self.last_name if self.human_name.nil?
      self.email = self.first_name.gsub(" ", "")  + "." + self.last_name.gsub(" ", "") + "@sv.cmu.edu" if self.email.nil?
    end 


  def emailed_recently(email_type)
    case email_type
      when :effort_log
        return self.effort_log_warning_email.nil? || (self.effort_log_warning_email < 1.day.ago) ? false : true
      when :sponsored_project_effort
        return self.sponsored_project_effort_last_emailed.nil? || (self.sponsored_project_effort_last_emailed < 1.day.ago) ? false : true
    end
  end

  def telephones
    phones = []
    phones << "#{self.telephone1_label}: #{self.telephone1}" unless (self.telephone1_label.nil? || self.telephone1_label.empty?)
    phones << "#{self.telephone2_label}: #{self.telephone2}" unless (self.telephone2_label.nil? || self.telephone2_label.empty?)
    phones << "#{self.telephone3_label}: #{self.telephone3}" unless (self.telephone3_label.nil? || self.telephone3_label.empty?)
    phones << "#{self.telephone4_label}: #{self.telephone4}" unless (self.telephone4_label.nil? || self.telephone4_label.empty?)
    return phones
  end

  def self.parse_twiki(username)
    # The regular expression matches on twiki usernames. Ie AliceSmithJones returns the array ["Alice", "SmithJones"]
    # This does not work with numbers or characters in the firstname field
    # http://rubular.com/
     match = username.match /([A-Z][a-z]*)([A-Z][\w]*)/
     if match.nil?
       return nil
     else
       return [match[1], match[2]]
     end
  end

  def find_teams_by_semester(year, semester)
    s_teams = []
    self.teams.each do |team|
      s_teams << team if team.course.year == year and team.course.semester == semester
    end
    return s_teams
  end


  def permission_level_of(role)
    case role
      when :student
        return (self.is_student? || self.is_staff? || self.is_admin?)
      when :staff
        return (self.is_staff? || self.is_admin?)
      when :admin
        return (self.is_admin?)
      else
        return false
    end
  end


   def get_registered_courses
    semester = AcademicCalendar.current_semester()

    @sql_str = "select c.* FROM courses c,teams t
              where t.course_id=c.id and c.year=#{Date.today.year} and c.semester='#{semester}' and t.id in
              (SELECT tp.team_id FROM teams_people tp, users u where u.id=tp.person_id and u.id=#{self.id})"

    @registered_courses = Course.find_by_sql(@sql_str)
  end

   #
   # Creates a Google Apps for University account for the user. For legacy reasons,
   # the accounts are with the domain west.cmu.edu even though the prefered way
   # of talking about the account is with the domain sv.cmu.edu
   #
   # Input is a password
   # If this fails, it retuns an error message as a string
   #
   def create_google_email(password)
     return "Empty email address" if self.email.blank?
     logger.debug("Attempting to create google email account for " + self.email)
     (username, domain) = switch_sv_to_west(self.email).split('@')
     
     if domain != GOOGLE_DOMAIN
       logger.debug("Domain (" + domain + ") is not the same as the google domain (" + GOOGLE_DOMAIN )
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
     self.save_without_session_maintenance
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
     agent.get(TWIKI_URL + '/do/view/TWiki/TWikiRegistration' ) do |page|
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
       self.save_without_session_maintenance
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
     self.save_without_session_maintenance
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


  def past_teams
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN users u ON (tp.person_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND (c.semester <> ? OR c.year <> ?)", self.id, AcademicCalendar.current_semester(), Date.today.year])
  end

  # Given ["Awesome", "Devils", "Alpha Omega"]
  # Returns "Awesome, Devils, Alpha Omega"
  def formatted_past_teams
    self.past_teams.map {|team| team.name} * ", "
  end
  
end
