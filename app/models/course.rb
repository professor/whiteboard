# Course represents a course taught at CMU-SV.
#
# At present, there is no distinction between sections of a course. Each team can belong to a "section"
# which is only a labeled text field.
#
# == Adding a Course Offering
#
# Sometime before a new semester starts, Gerry will create all the courses for the next semester. The HUB
# has a deadline for updating their system with courses, once that deadline has passed, Gerry typically will
# update the rails system. A course can be added/removed/modified after this deadline, and the information in
# the rails system should be updated. When Gerry creates a course, its will the minimal necessary information.
# When the course is created, certain information is copied from the previous offering of the same course, where as
# other information must not be copied.
#
# The CMU-SV community typically does not refer to courses by their number, where as on the Pittsburgh campus,
# most undergraduate courses are referred to by their number. 
#
# The system asks for the tuple (course_number, semester, and year) to create the course and then puts the user
# in an edit mode prompting reasonable defaults from the last time the course was offered. If nothing has changed,
# it's easy for Gerry to create the next course. If the instructor has changed then it's easy to edit that information
#
#
# == Notifying instructors
#
# Whenever an instructor is added to a course, they are notified about the change, asking them to review the course
# options. We ask that one of the instructors confirm the settings, when this happens we consider that the faculty
# has "configured" the course. (Or verified it's settings.) If this doesn't happen, the system should periodically
# remind faculty about the change.)
#
#

class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"

  has_many :faculty_assignments
  has_many :faculty, :through => :faculty_assignments, :source => :person #:join_table=>"courses_people", :class_name => "Person"


  validates_presence_of :semester, :year, :mini, :name

  versioned
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

  #before_validation :set_updated_by_user -- this needs to be done by the controller
  before_save :strip_whitespaces

  scope :unique_course_numbers_and_names_by_number, :select => "DISTINCT number, name", :order => 'number ASC'
  scope :unique_course_names, :select => "DISTINCT name", :order => 'name ASC'
  scope :in_current_semester_with_course_number, lambda { |number|
    where("number = ? and semester = ? and year = ?", number, AcademicCalendar.current_semester(), Date.today.year)
  }
  scope :with_course_name, lambda { |name|
    where("name = ?", name).order("id ASC")
  }

  def self.first_offering_for_course_name(course_name)
    Course.with_course_name(course_name).first
  end

  def self.for_semester(semester, year)
    return Course.where(:semester => semester, :year => year).order("name ASC")
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

  # Return the week number of the year for the start of a course
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

  # Return the week number of the year for the end of a course
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
    courses = Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), "both"])
    courses = courses + Course.find(:all, :conditions => ['remind_about_effort = true and year = ? and semester = ? and mini = ?', Date.today.cwyear, AcademicCalendar.current_semester(), AcademicCalendar.current_mini])
    return courses
  end

  def auto_generated_twiki_url
    return "http://info.sv.cmu.edu/do/view/#{self.semester}#{self.year}/#{self.short_or_full_name}/WebHome".delete(' ')
  end

  def auto_generated_peer_evaluation_date_start
    return Date.commercial(self.year, self.course_start + 6)
  end

  def auto_generated_peer_evaluation_date_end
    return Date.commercial(self.year, self.course_start + 7)
  end


  #Todo - create a test case for this
  #Todo - move to a higher class or try as a mixin
  #Todo - this code was copied to team.rb
  def update_faculty(members)
    self.faculty_was = self.faculty
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

  #Find the last time this course was offered
  def self.last_offering(course_number)
    #TODO: move this sorting into the database
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
  def strip_whitespaces
    @attributes.each do |attr, value|
      self[attr] = value.strip if value.is_a?(String)
    end
  end

end
