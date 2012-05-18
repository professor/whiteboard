class Team < ActiveRecord::Base
  belongs_to :course
  belongs_to :primary_faculty, :class_name=>'User', :foreign_key => "primary_faculty_id"
  belongs_to :secondary_faculty, :class_name=>'User', :foreign_key => "secondary_faculty_id"

  has_and_belongs_to_many :people, :join_table=>"teams_people"  #Old code uses the people associations which returns an array of person
  has_many :team_assignments
  has_many :users, :through => :team_assignments, :source => :user #:join_table=>"teams_people", :class_name => "Person"



  has_many :presentations

  validate :validate_members
  validates_presence_of :course_id, :name
  validates_uniqueness_of :email, :allow_blank => true, :message => "The team name has already be used in this semester. Pick another name"

  attr :team_members_list_changed, true

  #When assigning faculty to a page, the user types in a series of strings that then need to be processed
  #:members_override is a temporary variable that is used to do validation of the strings (to verify
  # that they are people in the system) and then to save the people in the faculty association.
  attr_accessor :members_override


  before_validation :clean_up_data, :update_email_address
  before_save :copy_peer_evaluation_dates_from_course, :need_to_update_google_list?, :update_members
  after_save :update_mailing_list

  before_destroy :remove_google_group

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
      Delayed::Job.enqueue(GoogleMailingListJob.new(self.email, self.email_was, self.people, self.name, "#{self.name} for course #{self.course.name}", self.id, "teams"))
      self.course.updating_email = true
      self.course.save
    end
  end


  def google_group
    self.email.split('@')[0] #strips out @sv.cmu.edu
  end

  def self.find_by_person(person)
    person_id = person.id
    Team.find_by_sql("SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) WHERE tp.person_id = #{person_id}")
  end

  def self.find_current_by_person(person)
    person_id = person.id
    current_year = Date.today.year()
    current_semester = AcademicCalendar.current_semester()
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN courses c ON (t.course_id = c.id) WHERE tp.person_id = ? AND c.semester = ? AND c.year = ?", person_id, current_semester, current_year])
  end

  def self.find_past_by_person(person)
    current_year = Date.today.year()
    current_semester = AcademicCalendar.current_semester()
    Team.find_by_sql(["SELECT t.* FROM  teams t INNER JOIN teams_people tp ON ( t.id = tp.team_id) INNER JOIN courses c ON (t.course_id = c.id) WHERE tp.person_id = ? AND (c.semester <> ? OR c.year <> ?)", person.id, current_semester, current_year])
  end


  def update_email_address
    self.email = generate_email_name unless self.name.blank?
  end


  #When modifying validate_members or update_members, modify the same code in course.rb
  #Todo - move to a higher class or try as a mixin
  def validate_members
    return "" if members_override.nil?

    self.members_override = members_override.select {|name| name != nil && name.strip != ""}
    list = map_member_stings_to_persons(members_override)
    list.each_with_index do |id, index|
      if id.nil?
        self.errors.add(:base, "Person " + members_override[index] + " not found")
      end
    end
  end

  def update_members
    return "" if members_override.nil?

    self.members_override = members_override.select {|name| name != nil && name.strip != ""}
    #if the list has changed
    if(self.members_override.sort != self.people.collect{|person| person.human_name}.sort)
      self.updating_email = true
      list = map_member_stings_to_persons(self.members_override)
      raise "Error converting members_override to IDs!" if list.include?(nil)
      self.people = list
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
    a = self.people
    self.people.include?(person)
  end


  def peer_evaluation_message_one
    return "Action Required: please do this peer evaluation survey\n\n by the end of " + self.peer_evaluation_second_email.to_date.to_formatted_s(:long)

  end

  def peer_evaluation_message_two_done
    return "According to my records, you have finished the peer evaluation. If you wanted to make any last minute changes to it, do it today."
  end

  def peer_evaluation_message_two_incomplete
    return "Action Required: please do this peer evaluation survey NOW. \n\n Today is your last day to do the peer evaluation."
  end

  def clone_to_another_course(destination_course_id)
      clone = self.clone
      clone.person_ids = self.person_ids
      clone.course_id = destinaton_course_id
      clone.name = self.name + " - " + destination_course_id    
      clone.save    
  end
                    


  protected
  def generate_email_name
      email = "#{self.course.semester}-#{self.course.year}-#{self.name}".chomp.downcase.gsub(/ /, '-') + "@" + GOOGLE_DOMAIN
      email = email.gsub('&','and')
      email.sub('@west.cmu.edu', '@sv.cmu.edu')
    end

  def remove_google_group
    logger.debug "trying before_destroy"
    google_apps_connection.delete_group(self.email)
  rescue GDataError => e
    logger.error "Attempting to destroy group.  errorcode = #{e.code}, input : #{e.input}, reason : #{e.reason}"
  end

  def map_member_stings_to_persons(members_override_list)
    members_override_list.map { |member_name| Person.find_by_human_name(member_name) }
  end

end
