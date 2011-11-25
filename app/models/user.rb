class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :rememberable, :trackable, :timeoutable
  #, :database_authenticatable, :registerable,

  # Setup accessible (or protected) attributes for your model
  attr_accessible :adobe_created, :biography, :email, :first_name, :github, :graduation_year, :human_name, :image_uri, :is_active, :is_adobe_connect_host, :is_alumnus, :is_part_time, :is_staff, :is_student, :is_teacher, :last_name, :legal_first_name, :local_near_remote, :login, :masters_program, :masters_track, :msdnaa_created, :office, :office_hours, :organization_name, :personal_email, :photo_content_type, :photo_file_name, :pronunciation, :skype, :sponsored_project_effort_last_emailed, :strength1_id, :strength2_id, :strength3_id, :strength4_id, :strength5_id, :telephone1, :telephone1_label, :telephone2, :telephone2_label, :telephone3, :telephone3_label, :telephone4, :telephone4_label, :tigris, :title, :twiki_name, :user_text, :webiso_account, :work_city, :work_country, :work_state
  #These attributes are not accessible , :created_at, :current_sign_in_at, :current_sign_in_ip, :effort_log_warning_email, :google_created, :is_admin, :last_sign_in_at, :last_sign_in_ip, :remember_created_at,  :sign_in_count,  :sign_in_count_old,  :twiki_created,  :updated_at,  :updated_by_user_id,  :version,  :yammer_created

   has_and_belongs_to_many :courses, :join_table=>"courses_users"


  scope :staff, :conditions => {:is_staff => true, :is_active => true}, :order => 'human_name ASC'
  scope :teachers, :conditions => {:is_teacher => true, :is_active => true}, :order => 'human_name ASC'

  scope :part_time_class_of, lambda { |program, year|
    where("is_part_time is TRUE and masters_program = ? and graduation_year = ?", program, year.to_s).order("human_name ASC")
#    where("masters_program = ? and graduation_year = ?",program, year.to_s).order("human_name ASC")
  }
  scope :full_time_class_of, lambda { |program, year|
    where("is_part_time is FALSE and masters_program = ? and graduation_year = ?", program, year.to_s).order("human_name ASC")
#    where("masters_program = ? and graduation_year = ?",program, year.to_s).order("human_name ASC")
  }

  def self.find_for_google_apps_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']
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


  #  before_save :initialize_human_name
  has_and_belongs_to_many :teams

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
      teams_students_map[team.course.year][team.course.semester.downcase] += team.people.count
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


  protected
  def initialize_human_name
    self.human_name = self.first_name + " " + self.last_name if self.human_name.nil?
  end

  def update_webiso_account
    self.webiso_account = Time.now.to_f.to_s if self.webiso_account.blank?
  end


  def person_before_save
    # We populate some reasonable defaults, but this can be overridden in the database
    self.human_name = self.first_name + " " + self.last_name if self.human_name.blank?
    self.email = self.first_name.gsub(" ", "") + "." + self.last_name.gsub(" ", "") + "@sv.cmu.edu" if self.email.blank?

    logger.debug("self.photo.blank? #{self.photo.blank?}")
    logger.debug("photo.url #{photo.url}")
    # update the image_uri if a photo was uploaded
    self.image_uri = self.photo.url(:profile).split('?')[0] unless (self.photo.blank? || self.photo.url == "/photos/original/missing.png")

  end


end
