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
# Course has grading rules. These include grading cut_offs for grade's like A,A-,B+ etc.

class Course < ActiveRecord::Base
  has_many :teams
  belongs_to :course_number
  has_many :pages, :order => "position"
  has_many :assignments, :order => "assignment_order"


  #----- delete this when implementing deliverable-----#
  has_many :deliverables

  has_many :faculty_assignments
  has_many :faculty, :through => :faculty_assignments, :source => :user

  has_many :teaching_assistant_assignments
  has_many :teaching_assistants, :through => :teaching_assistant_assignments, :source => :user

  has_many :registrations
  has_many :registered_students, :through => :registrations, :source => :user

  has_many :presentations

  has_many :grades, :through => :assignments

  has_one :grading_rule, :dependent => :destroy
  accepts_nested_attributes_for :grading_rule
  attr_accessible :grading_rule_attributes

  validates_presence_of :semester, :year, :mini, :name
  validate :validate_faculty_assignments
  validate :validate_teaching_assistant_assignments

  versioned
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by_user_id'
  belongs_to :configured_by, :class_name => 'User', :foreign_key => 'configured_by_user_id'

  #When assigning faculty to a page, the user types in a series of strings that then need to be processed
  # :faculty_assignments_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the faculty association.
  attr_accessor :faculty_assignments_override

  #When assigning teaching_assistant to a page, the user types in a series of strings that then need to be processed
  # :teaching_assistant_assignments_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the teaching_assistant association.
  attr_accessor :teaching_assistant_assignments_override

  attr_accessible :course_number_id, :name, :number, :semester, :mini, :primary_faculty_label,
                  :secondary_faculty_label, :twiki_url, :remind_about_effort, :short_name, :year,
                  :peer_evaluation_first_email, :peer_evaluation_second_email,
                  :curriculum_url, :configure_course_twiki,
                  :teaching_assistant_assignments_override,
                  :faculty_assignments_override

  include PeopleInACollection

  def validate_faculty_assignments
    validate_members :faculty_assignments_override
  end

  def validate_teaching_assistant_assignments
    validate_members :teaching_assistant_assignments_override
  end

#  def to_param
#    display_course_name
#  end

  def display_course_name
    mini_text = self.mini == "Both" ? "" : self.mini
    result = self.short_or_full_name + self.semester + mini_text + self.year.to_s
    result.gsub(" ", "")
  end

  def display_for_course_page
# Consider this
#    "#{self.number} #{self.name} (#{self.short_name}) #{self.display_semester}"
    "#{self.number} #{self.name} (#{self.short_name})"
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

  def short_or_course_number
    unless self.short_name.blank?
      self.short_name
    else
      self.number
    end
  end

  def display_semester
    mini_text = self.mini == "Both" ? "" : self.mini + " "
    return self.semester + " " + mini_text + self.year.to_s
  end

  #before_validation :set_updated_by_user -- this needs to be done by the controller
  before_save :strip_whitespaces, :update_email_address, :need_to_update_google_list?, :update_teaching_assistants, :update_faculty
  after_save :update_distribution_list

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
    return Course.where(:semester => semester, :year => year).order("name ASC").all
  end

  def self.current_semester_courses()
    return self.for_semester(AcademicCalendar.current_semester(),
                             Date.today.year)
  end

  def self.next_semester_courses()
    return self.for_semester(AcademicCalendar.next_semester(),
                             AcademicCalendar.next_semester_year())
  end

  def self.first_email_on_peer_evaluation_is_today
    Course.where(:peer_evaluation_first_email => Date.today).all
  end

  def self.second_email_on_peer_evaluation_is_today
    Course.where(:peer_evaluation_second_email => Date.today).all
  end


  def course_length
    if self.mini == "Both" then
      if semester == "Summer" then
        return 12
      elsif semester == "Fall" then
        return 15
      else
        return 16
      end
    else
      if semester == "Summer" then
        return 6
      else
        return 7
      end
    end
  end

  # Return the week number of the year for the start of a course
  def course_start
    start = AcademicCalendar.semester_start(semester, year)

    if semester == "Spring" then
      return self.mini == "B" ? start + 9 : start
    end
    if semester == "Summer" then
      return self.mini == "B" ? start + 6 : start
    end
    if semester == "Fall" then
      return self.mini == "B" ? start + 8 : start
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


  def self.remind_about_effort_course_list
    courses = Course.where(:remind_about_effort => true, :year => Date.today.cwyear, :semester => AcademicCalendar.current_semester(), :mini => "Both").all
    courses = courses + Course.where(:remind_about_effort => true, :year => Date.today.cwyear, :semester => AcademicCalendar.current_semester(), :mini => AcademicCalendar.current_mini).all
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

  #When modifying validate_faculty or update_faculty, modify the same code in team.rb
  #Todo - move to a higher class or try as a mixin
  def update_faculty
    return "" if faculty_assignments_override.nil?
    self.faculty = []

    self.faculty_assignments_override = faculty_assignments_override.select { |name| name != nil && name.strip != "" }
    list = map_member_strings_to_users(self.faculty_assignments_override)
    raise "Error converting faculty_assignments_override to IDs!" if list.include?(nil)
    self.faculty = list
    faculty_assignments_override = nil
    self.updating_email = true
  end

  #When modifying validate_teaching_assistant or update_teaching_assistant, modify the same code in team.rb
  #Todo - move to a higher class or try as a mixin
  def update_teaching_assistants
    return "" if teaching_assistant_assignments_override.nil?
    self.teaching_assistants = []

    self.teaching_assistant_assignments_override = teaching_assistant_assignments_override.select { |name| name != nil && name.strip != "" }
    list = map_member_strings_to_users(self.teaching_assistant_assignments_override)
    raise "Error converting teaching_assistant_assignments_override to IDs!" if list.include?(nil)
    self.teaching_assistants = list
    teaching_assistant_assignments_override = nil
    self.updating_email = true
  end

  def copy_as_new_course
    new_course = self.dup
    new_course.is_configured = false
    new_course.configured_by = nil
    new_course.updated_by = nil
    new_course.created_at = Time.now
    new_course.updated_at = Time.now
    new_course.curriculum_url = nil if self.curriculum_url.nil? || self.curriculum_url.include?("twiki")
    new_course.faculty = self.faculty
    new_course.teaching_assistants = self.teaching_assistants
    new_course.grading_rule = self.grading_rule.dup if self.grading_rule.present?
    self.assignments.each { |assignment| new_course.assignments << assignment.dup } if self.assignments.present?
    return new_course
  end

  #Find the last time this course was offered
  def self.last_offering(course_number)
    #TODO: move this sorting into the database
    offerings = Course.where(:number => course_number).all
    offerings = offerings.sort_by { |c| -c.sortable_value } # note the '-' is for desc sorting
    return offerings.first
  end

  def self.copy_courses_from_a_semester_to_next_year(semester, year)
    next_year = year + 1
    if Course.for_semester(semester, next_year).empty?
      Course.for_semester(semester, year).each do |last_year_course|
        puts last_year_course.id
        next_year_course = last_year_course.copy_as_new_course
        next_year_course.peer_evaluation_first_email += 1.year if next_year_course.peer_evaluation_first_email
        next_year_course.peer_evaluation_second_email += 1.year if next_year_course.peer_evaluation_second_email
        next_year_course.year = next_year
        next_year_course.save
      end
    else
      raise "There are already courses in semester #{semester} #{next_year}"
    end
  end

  def copy_teams_to_another_course(destination_course_id)
    #Todo: at some point, refactor teams to be an ordered list, so that we wouldn't need to reverse it here to preserve ordering.
    self.teams.reverse.each do |team|
      team.clone_to_another_course(destination_course_id)
    end
  end

  def current_mini?
    case self.mini
      when "Both"
        self.year == Date.today.year && self.semester == AcademicCalendar.current_semester()
      else
        self.year == Date.today.year && self.mini == AcademicCalendar.current_mini()
    end
  end

  def invalidate_distribution_list
    self.updating_email = true
  end

  def update_email_address
    self.email = build_email
  end

  def email_faculty_to_configure_course_unless_already_configured
    CourseMailer.configure_course_faculty_email(self).deliver unless self.is_configured?
  end


  def nomenclature_assignment_or_deliverable
    if self.grading_rule.nil? || self.grading_rule.is_nomenclature_deliverable?
      "deliverable"
    else
      "assignment"
    end
  end

  def grade_type_points_or_weights
    if self.grading_rule.nil? || self.grading_rule.grade_type=="points"
      "points"
    else
      "weights"
    end
  end

  def registered_students_or_on_teams
    self.registered_students | self.teams.collect { |team| team.members }.flatten
  end

  protected
  def strip_whitespaces
    @attributes.each do |attr, value|
      self[attr] = value.strip if value.is_a?(String)
    end
  end

  def build_email
    unless self.short_name.blank?
      email = "#{self.semester}-#{self.year}-#{self.short_name}".chomp.downcase.gsub(/ /, '-') + "@" + GOOGLE_DOMAIN
    else
      email = "#{self.semester}-#{self.year}-#{self.number}".chomp.downcase.gsub(/ /, '-') + "@" + GOOGLE_DOMAIN
    end
    email = email.gsub('&', 'and')
    email.sub('@west.cmu.edu', '@sv.cmu.edu')
  end

  def need_to_update_google_list?
    if self.email_changed?
      self.updating_email = true
    end
  end

  def update_distribution_list
    if self.updating_email
      recipients = self.faculty | self.registered_students_or_on_teams
      Delayed::Job.enqueue(GoogleMailingListJob.new(self.email, self.email, recipients, self.email, "Course distribution list", self.id, "courses"))
    end
  end

  # convenience method for an admin. destination_course_id is the first time that course was offered
  def copy_pages_to_another_course(destination_course_id, url_prefix)
    self.pages.each do |page|
      new = page.dup
      new.course_id = destination_course_id
      new.url = url_prefix + page.url
      new.save
    end
  end

  public

  def faculty_and_teaching_assistants
    faculty + teaching_assistants
  end

  def registered_students_and_students_on_teams_hash
    students = Hash.new
    self.registered_students.each do |student|
      students[student.human_name] = {:hub => true}
    end
    self.teams.each do |team|
      team.members.each do |user|
        students[user.human_name] = (students[user.human_name] || Hash.new).merge({:team => true, :team_name => team.name})
      end
    end
    return students
  end
end

