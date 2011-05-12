class Team < ActiveRecord::Base
  belongs_to :course
  belongs_to :primary_faculty, :class_name=>'User', :foreign_key => "primary_faculty_id"
  belongs_to :secondary_faculty, :class_name=>'User', :foreign_key => "secondary_faculty_id"
  has_and_belongs_to_many :people, :join_table=>"teams_people"
  
  
  validates_presence_of     :course_id
  validates_uniqueness_of   :email, :allow_blank => true, :message => "The team name has already be used in this semester. Pick another name"
  
#  validates_each :person_name, :person_name2, :allow_nil, :allow_blank do |record, attr, value|
#      record.errors.add attr, 'Person does not exist' if Person.find_by_human_name(value).nil?
#  end

  attr :old_email, true
  attr :old_name, true
  attr :team_members_list_changed, true

  def after_initialize
    #Note: refactor this code using the rails dirty login, ie email_changed? email_was, etc.
    self.old_email = self.email
  end

  def before_validation
    self.name = self.name.strip() unless self.name.blank?
    self.email = build_email unless self.name.blank?
  end

  def before_save
    return if self.name.blank?
    return unless self.old_email != self.email|| self.team_members_list_changed


    self.peer_evaluation_first_email = self.course.peer_evaluation_first_email if self.peer_evaluation_first_email.blank?
    self.peer_evaluation_second_email = self.course.peer_evaluation_second_email if self.peer_evaluation_second_email.blank?

    self.updating_email = true
    logger.debug("team.before_save() executed")
#    update_google_mailing_list(self.email, self.old_email, self.id)
#    self.send_later(:update_google_mailing_list, self.email, self.old_email, self.id)
    self.delay.update_google_mailing_list self.email, self.old_email, self.id
    self.email = self.email.sub('@west.cmu.edu','@sv.cmu.edu')

    current_user = UserSession.find.user unless UserSession.find.nil?
    if current_user && self.name_changed?
      self.name =  self.name_was unless self.course.configure_teams_name_themselves || current_user.permission_level_of(:staff)
    end

  end



  def update_google_mailing_list(new_email, old_email, id)
    logger.info("team.update_google_mailing_list(#{new_email}, #{old_email}, #{id}) executed")

    new_group = new_email.split('@')[0] unless new_email.blank?
    old_group = old_email.split('@')[0] unless old_email.blank?

    new_group_exists = false
    old_group_exists = false
    google_apps_connection.retrieve_all_groups.each do |list|
      group_name = list.group_id.split('@')[0]
      old_group_exists = true if old_group == group_name
      new_group_exists = true if new_group == group_name
    end
    if old_group_exists
      logger.info "Deleting #{old_group}"
      google_apps_connection.delete_group(old_group)
      new_group_exists = false if old_group == new_group
    end

    if !new_group_exists
      logger.info "Creating #{new_group}"
      google_apps_connection.create_group(new_group, [self.name, "#{self.name} for course #{self.course.name}", "Domain"])
    end
    self.people.each do |member|
      logger.info "Teams:adding #{member.email}"
      google_apps_connection.add_member_to_group(member.email, new_group)
    end


    #verify that this method worked. If it didn't an error will be raised and it will be run again through delayed job
    all_team_members = google_apps_connection.retrieve_all_members(new_group)
    google_list = all_team_members.map{|l| l.member_id}.sort
    team_list = self.people.map{|l| l.email}.sort
    unless google_list.eql?(team_list)
      logger.warn("The people on the google list isn't right")
      logger.warn("google list: #{google_list} ")
      logger.warn("team list: #{team_list} ")
    end
    raise Exception.new("The people on the google list isn't right") unless google_list.eql?(team_list)

    ActiveRecord::Base.connection.execute "UPDATE teams SET updating_email=false WHERE id=#{id}";
    logger.info "#{id} -- finished"

  end
#  handle_asynchronously :update_google_mailing_list

  def after_save
    self.old_email = self.email
  end

  def before_destroy
    logger.debug "trying before_destroy"
    google_apps_connection.delete_group(self.email)
  rescue GDataError => e
    logger.error "Attempting to destroy group.  errorcode = #{e.code}, input : #{e.input}, reason : #{e.reason}"
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


  #deprecated;
  #TODO delete this method
#  def load_old_email
#    old = Team.find_by_id(self.id, :select => :email)
#    return "undefined" if old == nil
#    oldemail = old.attribute_for_inspect(:email)
#    if oldemail == "nil"
#      return "undefined"
#    else
#      return oldemail.split('"')[1]
#    end
#  end
#  def email_changed?
#    #logger.debug "\nDEBUG: build_email<#{self.build_email}> vs. old_email<#{self.old_email}>"
#    return self.build_email != self.old_email
#  end

  def remove_person(id)
    person = Person.find_by_id(id)
    if self.people.include?(person)
      self.people.delete person
      google_apps_connection.remove_member_from_group(person.email, self.google_group) unless self.name.blank?
#      async_google_remove_member(person.email,self.google_group)
    else
      logger.error "Attempting to remove person #{person.human_name} who is not in team #{self.name}"
    end
    rescue ActiveRecord::RecordNotFound
      logger.error "Attempting to remove an unknown person with id=#{id}"
    rescue GAppsProvisioning::GDataError
      logger.error "Probably trying to remove a person from a team that no longer has a google email."    
  end

  def add_person_by_human_name(name)
    person = Person.find_by_human_name(name) unless name.blank?
  rescue ActiveRecord::RecordNotFound
    logger.error "Attempting to add an unknown person with name=#{name}"
    errors.add(:person_name, "Person " + name + " not found")
  else
    unless person == nil or self.people.include?(person) # prevent duplicat people in same team
      self.people << person
      google_apps_connection.add_member_to_group(person.email, self.google_group)
#      async_google_add_member(person.email,self.build_email)

    end
    person
  end

  def build_email
#    return "#{self.course.semester}-#{self.course.year}-#{self.name}".chomp.downcase.gsub(/ /, '-') + "@sv.cmu.edu"
    return "#{self.course.semester}-#{self.course.year}-#{self.name}".chomp.downcase.gsub(/ /, '-') + "@" + GOOGLE_DOMAIN
  end


  
  
  def person_name
    
  end
  def person_name2
    
  end
  def person_name3
    
  end
  def person_name4
    
  end
  def person_name5
    
  end
  def person_name6
    
  end

  def add_person_to_team(name)
    logger.debug("add_person_to_team(#{name})")
    unless name.blank?
      self.team_members_list_changed = true
      person = Person.find_by_human_name(name)
      if person.nil?
        errors.add(:person_name, "Person " + name + " not found")
      else
        self.people << person
      end
#     this line only needed if this were converted to an ajax call
#      google_apps_connection.add_member_to_group(person.email, self.google_group) unless self.name.blank?
    end
  end

  def person_name=(name)
    add_person_to_team(name)
  end
  def person_name2=(name)
    add_person_to_team(name)
  end
  def person_name3=(name)
    add_person_to_team(name)
  end
  def person_name4=(name)
    add_person_to_team(name)
  end
  def person_name5=(name)
    add_person_to_team(name)
  end
  def person_name6=(name)
    add_person_to_team(name)
  end

  def show_addresses_for_mailing_list
    begin
      @members = []
      google_apps_connection.retrieve_all_members(self.google_group).each do |member|
        @members << member.member_id.sub('@west.cmu.edu','@sv.cmu.edu')
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

end
