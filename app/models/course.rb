class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"

  has_many :faculty_assignments
  has_many :faculty, :through => :faculty_assignments, :source => :person #:join_table=>"courses_people", :class_name => "Person"


  validates_presence_of :semester, :year, :mini, :name

  versioned
  validates_presence_of :updated_by_user_id
  belongs_to :updated_by, :class_name=>'User', :foreign_key => 'updated_by_user_id'
  belongs_to :configured_by, :class_name=>'User', :foreign_key => 'configured_by_user_id'


#  def to_param
#    display_course_name
#  end

  def display_course_name
    mini_text = self.mini == "Both" ? "" : self.mini
   result = self.short_or_full_name + self.semester + mini_text + self.year.to_s
   result.gsub(" ", "")
  end

  before_validation :set_updated_by_user

  scope :unique_course_numbers_and_names_by_number, :select => "DISTINCT number, name", :order => 'number ASC'
  scope :unique_course_numbers_and_names, :select => "DISTINCT number, name", :order => 'name ASC'

#  def self.for_semester(semester, year, mini)
#    return Course.find(:all, :conditions => ["semester = ? and year = ? and mini = ?", semester, year, mini], :order => "name number")
#  end
  
  def self.for_semester(semester, year)
    return Course.find(:all, :conditions => ["semester = ? and year = ?", semester, year], :order => "name ASC")
  end

  def self.current_semester_courses()
    return self.for_semester(AcademicCalendar.current_semester(),
                      Date.today.year)

  end

  def self.next_semester_courses()
    return self.for_semester(AcademicCalendar.next_semester(),
                             AcademicCalendar.next_semester_year())
  end


  def course_length
    if self.mini == "Both" then
      if semester == "Summer" then 
        return 12 
      else
        return 15
      end
    else 
      return 7
    end    
  end

  def course_start
    start = AcademicCalendar.semester_start(semester, year)

    if semester == "Spring" then
      return self.mini == "B" ? start + 7 : start
    end
    if semester == "Summer" then
      return self.mini == "B" ? start + 6 : start
    end
    if semester == "Fall" then
      return self.mini == "B" ? start + 7 : start
    end
    return 0 #If the semester field isn't set
  end
  
  def course_end
    self.course_start + self.course_length - 1
  end

  def sortable_value
    self.year.to_i * 100 + self.course_end
  end

  def display_name
    return self.name if self.short_name.blank?
    return self.name + " (" + self.short_name + ")"
  end

  def short_or_full_name
    unless self.short_name.blank?
      self.short_name
    else
      self.name
    end
  end

  def display_semester
    mini_text = self.mini == "Both" ? "" : self.mini + " "
    return self.semester + " " + mini_text + self.year.to_s
  end

  def self.remind_about_effort_course_list
    courses = Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), "both"] )
    courses = courses + Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), AcademicCalendar.current_mini] )
    return courses
  end

  def auto_generated_twiki_url
    return "http://info.sv.cmu.edu/do/view/#{self.semester}#{self.year}/#{self.short_or_full_name}/WebHome".delete(' ')
  end

  def auto_generated_peer_evaluation_date_start
    return Date.commercial(self.year,self.course_start + 6)
  end

  def auto_generated_peer_evaluation_date_end
   return Date.commercial(self.year, self.course_start + 7)
  end


  #Todo - create a test case for this
  #Todo - move to a higher class or try as a mixin
  #Todo - this code was copied to team.rb
  def update_faculty(members)
    self.faculty = []
    return "" if members.nil?

    msg = ""
    members.each do |name|
       person = Person.find_by_human_name(name)
       if person.nil?
         all_valid_names = false
         msg = msg + "'" + name + "' is not in the database. "
         #This next line doesn't quite seem to work
         self.errors.add(:person_name, "Person " + name + " not found")
       else
         self.faculty << person
       end
    end
    return msg
  end

  def copy_as_new_course
    new_course = self.clone
    new_course.is_configured = false
    new_course.curriculum_url = nil if self.curriculum_url.nil? || self.curriculum_url.include?("twiki")
    new_course.faculty = self.faculty
    return new_course
  end

  def self.last_offering(course_number)
    offerings = Course.find_all_by_number(course_number)
    offerings = offerings.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting
    return offerings.first
  end

  def email_faculty_to_configure
    unless self.is_configured?
      CourseMailer.deliver_configure_course_faculty_email(self)
    end
  end

  protected
  def set_updated_by_user
     current_user = UserSession.find.user unless UserSession.find.nil?
     self.updated_by_user_id = current_user.id if current_user
  end
end
