class User < ActiveRecord::Base
  acts_as_authentic
#
#  acts_as_authentic do |c|
#    c.my_config_option = my_value
#  end # the configuration block is optional  include
  
#  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false, :allow_nil => true
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

#  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
#  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  validates_uniqueness_of   :webiso_account,    :case_sensitive => false, :allow_nil => true

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :first_name, :last_name, :webiso_account, :isStaff, :isStudent, :isAdmin, :twiki_name

  
  # Lines modified by Todd go here:
  
   def before_save 
      self.human_name = self.first_name + " " + self.last_name if self.human_name.nil?
    end 
   has_and_belongs_to_many :teams    

#  belongs_to :person
#  def is_student?
#    person.is_student?
#  end
#  def is_staff?
#    person.is_staff?
#  end


  def emailed_recently
    return false if self.effort_log_warning_email.nil?
    return false if self.effort_log_warning_email < 1.day.ago
    return true
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

  protected
    


end
