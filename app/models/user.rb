class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable, :timeoutable
  #, :database_authenticatable, :registerable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :adobe_created, :biography, :email, :first_name, :github, :graduation_year, :human_name, :image_uri, :is_active, :is_adobe_connect_host, :is_ga_promised, :is_alumnus, :is_part_time, :is_staff, :is_student, :last_name, :legal_first_name, :local_near_remote, :login, :masters_program, :masters_track, :msdnaa_created, :office, :office_hours, :organization_name, :personal_email, :photo_first_content_type, :photo_first_file_name, :photo_second_content_type, :photo_second_file_name, :photo_custom_content_type, :photo_custom_file_name, :pronunciation, :skype, :sponsored_project_effort_last_emailed, :telephone1, :telephone1_label, :telephone2, :telephone2_label, :telephone3, :telephone3_label, :telephone4, :telephone4_label, :tigris, :title, :twiki_name, :user_text, :webiso_account, :work_city, :work_country, :work_state, :linked_in, :facebook, :twitter, :google_plus, :people_search_first_accessed_at, :is_profile_valid, :image_uri_first, :image_uri_second, :image_uri_custom, :photo_selection
  #These attributes are not accessible , :created_at, :current_sign_in_at, :current_sign_in_ip, :effort_log_warning_email, :google_created, :is_admin, :last_sign_in_at, :last_sign_in_ip, :remember_created_at,  :sign_in_count,  :sign_in_count_old,  :twiki_created,  :updated_at,  :updated_by_user_id,  :version,  :yammer_created, :course_tools_view, :course_index_view, :expires_at

  #We version the user table except for some system change reasons e.g. the Scotty Dog effort log warning email caused this save to happen
  acts_as_versioned :table_name => 'user_versions', :foreign_key => :user_id, :if => Proc.new { |user| !(user.effort_log_warning_email_changed? ||
      user.sponsored_project_effort_last_emailed_changed? ||
      user.course_tools_view_changed? ||
      user.course_index_view_changed? ||
      user.google_created_changed? ||
      user.remember_token_changed? ||
      user.remember_created_at_changed? ||
      user.last_sign_in_at_changed? ||
      user.current_sign_in_at_changed? ||
      user.sign_in_count_changed? ||
      user.twiki_created?) }

  has_many :registrations
  has_many :registered_courses, :through => :registrations, :source => :course

  has_many :faculty_assignments
  has_many :teaching_these_courses, :through => :faculty_assignments, :source => :course

  has_many :team_assignments
  has_many :teams, :through => :team_assignments, :source => :team

  has_many :people_search_defaults, :dependent => :destroy

  has_many :grades

  has_many :job_employees
  has_many :jobs_as_employee, :through => :job_employees, :source => :job
  has_many :job_supervisors
  has_many :jobs_as_supervisor, :through => :job_supervisors, :source => :job

  belongs_to :updated_by_user, :class_name => "User"

  before_validation :update_webiso_account
  before_save :person_before_save,
              :update_is_profile_valid

  before_create :set_new_user_token

  validates_uniqueness_of :webiso_account, :case_sensitive => false
  validates_uniqueness_of :email, :case_sensitive => false

  has_attached_file :photo_first, :storage => :s3, :styles => {:original => "", :profile => "150x200>"},
                    :bucket => ENV['WHITEBOARD_S3_BUCKET'],
                    :s3_credentials => {:access_key_id => ENV['WHITEBOARD_S3_KEY'],
                                        :secret_access_key => ENV['WHITEBOARD_S3_SECRET']},
                    :path => "people/:id/photo_first/:style/:filename"
  has_attached_file :photo_second, :storage => :s3, :styles => {:original => "", :profile => "150x200>"},
                    :bucket => ENV['WHITEBOARD_S3_BUCKET'],
                    :s3_credentials => {:access_key_id => ENV['WHITEBOARD_S3_KEY'],
                                        :secret_access_key => ENV['WHITEBOARD_S3_SECRET']},
                    :path => "people/:id/photo_second/:style/:filename"
  has_attached_file :photo_custom, :storage => :s3, :styles => {:original => "", :profile => "150x200>"},
                    :bucket => ENV['WHITEBOARD_S3_BUCKET'],
                    :s3_credentials => {:access_key_id => ENV['WHITEBOARD_S3_KEY'],
                                        :secret_access_key => ENV['WHITEBOARD_S3_SECRET']},
                    :path => "people/:id/photo_custom/:style/:filename"

  validates_attachment_content_type :photo_first, :content_type => ["image/jpeg", "image/png", "image/gif"], :unless => "!photo_first.file?"
  validates_attachment_content_type :photo_second, :content_type => ["image/jpeg", "image/png", "image/gif"], :unless => "!photo_second.file?"
  validates_attachment_content_type :photo_custom, :content_type => ["image/jpeg", "image/png", "image/gif"], :unless => "!photo_custom.file?"

  scope :staff, :conditions => {:is_staff => true, :is_active => true}, :order => 'human_name ASC'

  scope :part_time_class_of, lambda { |program, year|
    where("is_part_time is TRUE and masters_program = ? and graduation_year = ?", program, year.to_s).order("human_name ASC")
  }
  scope :full_time_class_of, lambda { |program, year|
    where("is_part_time is FALSE and masters_program = ? and graduation_year = ?", program, year.to_s).order("human_name ASC")
  }

  def self.get_all_programs
    User.select(:masters_program).map(&:masters_program).uniq.reject { |e| e.blank? }.sort
  end

  def self.get_all_years
    User.select(:graduation_year).map(&:graduation_year).uniq.reject { |e| e.blank? }.sort.reverse
  end


  def to_param
    if twiki_name.blank?
      id.to_s
    else
      twiki_name
    end
  end

  def self.find_by_param(param)
    if param.to_i == 0 #This is a string
      User.find_by_twiki_name(param)
    else #This is a number
      User.find(param)
    end
  end


  def teaching_these_courses_during_current_semester
    teaching_these_courses.where(:semester => AcademicCalendar.current_semester, :year => Date.today.year)
  end

  def registered_for_these_courses_during_current_semester
    hub_registered_courses = registered_courses.where(:semester => AcademicCalendar.current_semester, :year => Date.today.year).all

    sql_str = "select c.* FROM courses c,teams t
              where t.course_id=c.id and c.year=#{Date.today.year} and c.semester='#{AcademicCalendar.current_semester()}' and t.id in
              (SELECT ta.team_id FROM team_assignments ta, users u where u.id=ta.user_id and u.id=#{self.id})"
    courses_assigned_on_teams = Course.find_by_sql(sql_str)

    @registered_courses = hub_registered_courses | courses_assigned_on_teams
  end

  def registered_for_these_courses_during_past_semesters
    self.registered_courses - self.registered_for_these_courses_during_current_semester
  end


  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['info']
    email = switch_west_to_sv(data["email"]).downcase
    User.find_by_email(email)
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.google_apps_data"] && session["devise.google_apps_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end


  def emailed_recently(email_type)
    case email_type
      when :effort_log
        return self.effort_log_warning_email.nil? || (self.effort_log_warning_email < 1.day.ago) ? false : true
      when :sponsored_project_effort
        return self.sponsored_project_effort_last_emailed.nil? || (self.sponsored_project_effort_last_emailed < 1.day.ago) ? false : true
    end
  end

  #This method contributed by Team Juran
  def faculty_teams_map(person_id = self.id)
    faculty_teams = Team.find_by_sql(["SELECT t.* FROM  teams t WHERE t.primary_faculty_id = ? OR t.secondary_faculty_id = ?", person_id, person_id])

    teams_map = {}
    teams_students_map = {}
    for team in faculty_teams
      if teams_map[team.course.year].nil?
        teams_map[team.course.year] = {}
        teams_students_map[team.course.year] = {}
      end
      if teams_map[team.course.year][team.course.semester.downcase].nil?
        teams_map[team.course.year][team.course.semester.downcase] = []
        teams_students_map[team.course.year][team.course.semester.downcase] = 0
      end
      teams_map[team.course.year][team.course.semester.downcase].push(team)
      teams_students_map[team.course.year][team.course.semester.downcase] += team.members.count
    end
    # teams_map is a two dimentional hash holding arrays of courses
    # teams_students_map is a two dimentional hash holding an integer count
    # of students that are part of the courses for a given semester
    return [teams_map, teams_students_map]
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


  def telephones
    phones = []
    phones << "#{self.telephone1_label}: #{self.telephone1}" unless (self.telephone1_label.nil? || self.telephone1_label.empty?)
    phones << "#{self.telephone2_label}: #{self.telephone2}" unless (self.telephone2_label.nil? || self.telephone2_label.empty?)
    phones << "#{self.telephone3_label}: #{self.telephone3}" unless (self.telephone3_label.nil? || self.telephone3_label.empty?)
    phones << "#{self.telephone4_label}: #{self.telephone4}" unless (self.telephone4_label.nil? || self.telephone4_label.empty?)
    return phones
  end

  def telephones_hash
    phones = Hash.new
    phones[self.telephone1_label] = self.telephone1 unless (self.telephone1_label.nil? || self.telephone1_label.empty?)
    phones[self.telephone2_label] = self.telephone2 unless (self.telephone2_label.nil? || self.telephone2_label.empty?)
    phones[self.telephone3_label] = self.telephone3 unless (self.telephone3_label.nil? || self.telephone3_label.empty?)
    phones[self.telephone4_label] = self.telephone4 unless (self.telephone4_label.nil? || self.telephone4_label.empty?)
    return phones
  end

  # The regular expression matches on twiki usernames. Ie AliceSmithJones re
  # This does not work with numbers or characters in the firstname field
  # http://rubular.com/
  def self.camelcase_twiki_regex
    /([A-Z][a-z]*)([A-Z][\w]*)/
  end

  def self.parse_twiki(username)
    match = username.match camelcase_twiki_regex
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


  def initialize_human_name
    self.human_name = self.first_name + " " + self.last_name if self.human_name.nil?
  end

  def update_webiso_account
    self.webiso_account = Time.now.to_f.to_s if self.webiso_account.blank?
  end

  #Todo: This method looks similiar to one in helpers/teams_helper.rb -- if so DRY!
  def past_teams
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN team_assignments ta ON ( t.id = ta.team_id) INNER JOIN users u ON (ta.user_id = u.id) INNER JOIN courses c ON (t.course_id = c.id) WHERE u.id = ? AND (c.semester <> ? OR c.year <> ?)", self.id, AcademicCalendar.current_semester(), Date.today.year])
  end

  # Given an array of team objects [Awesome, Devils, Alpha Omega]
  # Returns "Awesome, Devils, Alpha Omega"
  def formatted_teams(array)
    array.map { |team| team.name } * ", "
  end


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

  #def create_yammer_account
  #  #See lib/yammer.rb for code that would create the user account.
  #  #We can't use the yammer API until we upgrade the service
  #
  #  #The most simple way here is to invite the user to register
  #  #Note that yammer requires https://www.yammer.com/
  #  require 'mechanize'
  #  agent = Mechanize.new
  #  agent.get('https://www.yammer.com/') do |page|
  #    result_page = page.form_with(:action => '/users') do |invite_page|
  #      invite_page['user[email]'] = self.email
  #    end.submit
  #  end
  #
  #  self.yammer_created = Time.now()
  #  self.save
  #  return true
  #end


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


  # attribute :github
  # If the user has not set this attribute, then ask the user to do so
  def notify_about_missing_field(attribute, message)
    if self.send(attribute).blank?
      options = {:to => self.email,
                 :subject => "Your user account needs updating",
                 :message => message,
                 :url_label => "Modify your profile",
                 :url => Rails.application.routes.url_helpers.edit_user_url(self, :host => "whiteboard.sv.cmu.edu")
      }
      GenericMailer.email(options).deliver
    end
  end

  def should_be_redirected?
    if self.people_search_first_accessed_at.nil?
      self.people_search_first_accessed_at = Time.now
      self.save!
    end
    #self.first_access = nil
    #self.save!
    ((Time.now - self.people_search_first_accessed_at)>4.weeks) ? true : false
    #true
    #false
  end

  def self.expired_users_in_the_last_month
    User.where(is_active: true).where("expires_at >= ? AND expires_at < ?", Date.today - 1.month, Date.today)
  end

  def self.notify_it_about_expired_accounts
    email_list = ""
    self.expired_users_in_the_last_month.each do |user|
      email_list += "-" + Rails.application.routes.url_helpers.user_url(user, :host => "whiteboard.sv.cmu.edu") + "\n"
    end
    if email_list.length > 0
      options = {:to => 'help@sv.cmu.edu',
                 :subject => "Expired accounts between #{(Date.today - 1.month).to_s} and #{(Date.today - 1.day).to_s}",
                 :message => "\n#{email_list} \n\n Please executed the processes defined for expired accounts."
      }
      GenericMailer.email(options).deliver
    end
  end

  def set_new_user_token
    self.new_user_token = SecureRandom.urlsafe_base64
  end

  def set_password_reset_token
    self.password_reset_token = SecureRandom.urlsafe_base64
  end

  protected

  def person_before_save
    # We populate some reasonable defaults, but this can be overridden in the database
    self.human_name = self.first_name + " " + self.last_name if self.human_name.blank?
    self.email = self.first_name.gsub(" ", "") + "." + self.last_name.gsub(" ", "") + "@sv.cmu.edu" if self.email.blank?

    # update the image_uri if a photo was uploaded

    self.image_uri_first = self.photo_first.url(:profile).split('?')[0] unless (self.photo_first.blank? || self.photo_first.url == ActionController::Base.helpers.asset_path("mascot.jpg"))
    self.image_uri_second = self.photo_second.url(:profile).split('?')[0] unless (self.photo_second.blank? || self.photo_second.url == ActionController::Base.helpers.asset_path("mascot.jpg"))
    self.image_uri_custom = self.photo_custom.url(:profile).split('?')[0] unless (self.photo_custom.blank? || self.photo_custom.url == ActionController::Base.helpers.asset_path("mascot.jpg"))

    case self.photo_selection
      when "first"
        self.image_uri = self.image_uri_first
      when "second"
        self.image_uri = self.image_uri_second
      when "custom"
        self.image_uri = self.image_uri_custom
      when "anonymous"
        self.image_uri = ActionController::Base.helpers.asset_path("mascot.jpg")
    end

  end

  def update_is_profile_valid
    if ((self.biography.blank? && self.facebook.blank? && self.twitter.blank? && self.google_plus.blank? && self.linked_in.blank?) or
        (self.telephone1.blank? && self.telephone2.blank? && self.telephone3.blank? && self.telephone4.blank?))
      self.is_profile_valid = false
    else
      self.is_profile_valid= true
    end
    return true
  end


end
