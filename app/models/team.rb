class Team < ActiveRecord::Base
  belongs_to :course
  belongs_to :primary_faculty, :class_name => 'User', :foreign_key => "primary_faculty_id"
  belongs_to :secondary_faculty, :class_name => 'User', :foreign_key => "secondary_faculty_id"

  has_many :team_assignments
  has_many :members, :through => :team_assignments, :source => :user

  has_many :presentations

  validate :validate_team_members
  validates_presence_of :course_id, :name
  validates_uniqueness_of :email, :allow_blank => true, :message => "The team name has already be used in this semester. Pick another name"

  attr :team_members_list_changed, true

  before_validation :clean_up_data, :update_email_address
  before_save :copy_peer_evaluation_dates_from_course, :need_to_update_google_list?, :update_members
  after_save :update_mailing_list

  before_destroy :remove_google_group

  #When assigning faculty to a page, the user types in a series of strings that then need to be processed
  #:members_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the faculty association.
  attr_accessor :members_override

  include PeopleInACollection

  def validate_team_members
    validate_members :members_override
  end

  def clean_up_data
    self.name = self.name.strip() unless self.name.blank?
  end

  def copy_peer_evaluation_dates_from_course
    self.peer_evaluation_first_email = self.course.peer_evaluation_first_email if self.peer_evaluation_first_email.blank?
    self.peer_evaluation_second_email = self.course.peer_evaluation_second_email if self.peer_evaluation_second_email.blank?
  end

  def need_to_update_google_list?
    if self.email_changed?
      self.updating_email = true
    end
  end

  def update_mailing_list
    tmp = self.updating_email
    if self.updating_email
      Delayed::Job.enqueue(GoogleMailingListJob.new(self.email, self.email_was, self.members, self.name, "#{self.name} for course #{self.course.name}", self.id, "teams"))
      self.course.updating_email = true
      self.course.save
    end
  end


  def google_group
    self.email.split('@')[0] #strips out @sv.cmu.edu
  end

  def self.find_by_person(user)
    Team.find_by_sql("SELECT t.* FROM  teams t INNER JOIN team_assignments ta ON ( t.id = ta.team_id) WHERE ta.user_id = #{user.id}")
  end

  def self.find_current_by_person(user)
    current_year = Date.today.year()
    current_semester = AcademicCalendar.current_semester()
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN team_assignments ta ON ( t.id = ta.team_id) INNER JOIN courses c ON (t.course_id = c.id) WHERE ta.user_id = ? AND c.semester = ? AND c.year = ?", user.id, current_semester, current_year])
  end

  def self.find_past_by_person(user)
    current_year = Date.today.year()
    current_semester = AcademicCalendar.current_semester()
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN team_assignments ta ON ( t.id = ta.team_id) INNER JOIN courses c ON (t.course_id = c.id) WHERE ta.user_id = ? AND (c.semester <> ? OR c.year <> ?)", user.id, current_semester, current_year])
  end


  def update_email_address
    self.email = generate_email_name unless self.name.blank?
  end


  #When modifying validate_members or update_members, modify the same code in course.rb
  #Todo - move to a higher class or try as a mixin
  def update_members
    return "" if members_override.nil?

    self.members_override = members_override.select { |name| name != nil && name.strip != "" }
    #if the list has changed
    if (self.members_override.sort != self.members.collect { |person| person.human_name }.sort)
      self.updating_email = true
      list = map_member_strings_to_users(self.members_override)
      raise "Error converting members_override to IDs!" if list.include?(nil)
      self.members = list
    end
    members_override = nil
  end

  def show_addresses_for_mailing_list
    begin
      @members = []
      google_apps_connection.retrieve_all_members(self.google_group).each do |member|
        @members << member.member_id.sub('@west.cmu.edu', '@sv.cmu.edu')
      end
      return @members
    rescue GDataError => e
      return [pretty_print_google_error(e)]
    end
  end

  def faculty_email_addresses
    faculty = []
    unless self.primary_faculty_id.nil?
      from_address = User.find_by_id(self.primary_faculty_id).email
      faculty << from_address
    end
    unless self.secondary_faculty_id.nil?
      #if there is a coach listed we want the email to come from the coach
      from_address = User.find_by_id(self.secondary_faculty_id).email
      faculty << from_address
    end
    return faculty
  end

  def is_person_on_team?(person)
    user = User.find(person.id)
    self.members.include?(user)
  end

  def is_user_on_team?(user)
    self.members.include?(user)
  end

  def peer_evaluation_message_one
    return "Action Required: please do this peer evaluation survey\n\n by the end of " + self.course.peer_evaluation_second_email.to_date.to_formatted_s(:long)

  end

  def clone_to_another_course(destination_course_id)
    destination_course = Course.find(destination_course_id)
    clone = self.clone
    clone.member_ids = self.member_ids
    clone.course_id = destination_course_id
    clone.name = self.name + " - " + destination_course.short_or_course_number
    clone.save
  end


  protected
  def generate_email_name
    email = "#{self.course.semester}-#{self.course.year}-#{self.name}".chomp.downcase.gsub(/ /, '-') + "@" + GOOGLE_DOMAIN
    email = email.gsub('&', 'and')
    email.sub('@west.cmu.edu', '@sv.cmu.edu')
  end

  def remove_google_group
    logger.debug "trying before_destroy"
    google_apps_connection.delete_group(self.email)
  rescue GDataError => e
    logger.error "Attempting to destroy group.  errorcode = #{e.code}, input : #{e.input}, reason : #{e.reason}"
  end

end
