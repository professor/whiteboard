# Deliverable is a zip or a file that the students submit for a course
#
# There are two ways for a student team to upload their deliverables.
#
# Way 1) On the curriculum pages for each task,  under the "Submitting Your Work" tab, there is a
# "submit your deliverable link" -- this gives the student the ability to name their deliverable, and upload a
# single attachment (i.e. one doc, ppt, or zip file). By default a Course Number and the Assignments are  provided for
# the student. Student needs to choose which asignment he/she is going to submit. The deliverable is individual or team
# deliverable will be checked on the basis of the assignment he/she is submitting. If a faculty member tries to do this,
# they won't see any courses lists since they aren't taking the course as a student.
# Students can submit only team deliverable and one individual deliverable per task, although they can update the
# attachment as many times as they like.
#
# Every member of a team can see team deliverables, only the individual can see their individual deliverable.
#
# Way 2) A student team can upload their deliverable by clicking on "My Deliverables" on the left hand navigation and
# select "New" at the bottom of the page. This is a little less efficient because the student needs to select a
# course and task number. It is a quick way for a student to see everything they have submitted for their courses.
#
# If a student or team accidentally uploads the wrong file, they can upload additional files. All files are
# kept in the system, but the convention is that the faculty will only examine the last uploaded file.
#
# The faculty assigned to that team will receive an email whenever a student submits a deliverable. The faculty
# can click on the email and provide either written comments in an text area or provide a file attachment back.
# If you annotate a word document you would upload the word document.
# If you annotate multiple files then you would attach a zip, just like the students do.
#
# If the faculty needs to see who has provided feedback or if they loose the email sent by the system, there is a f
# faculty interface for examining the deliverables. It is not perfect, it was developed by the students and they
# didn't have a strong sense of how we would use it. It currently shows all the deliverables submitted
# for a course sorted by recent changes first. There is no way to filter by faculty member, or sort by task,
# or sort by team, or sort by whether feedback has been provided. Control F in the browser is a life saver.
# It does show you which deliverables have been graded. In theory, just relying on the emails should be sufficient.


class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :course

  belongs_to :creator, :class_name => "User"
  has_many :attachment_versions, :class_name => "DeliverableAttachment", :order => "submission_date DESC"
  delegate :is_team_deliverable, :to => :assignment, :allow_nil => true


  #-----for assignment----#
  belongs_to :assignment

  validates_presence_of :course, :creator, :assignment
  validate :unique_course_task_owner?

  has_attached_file :feedback,
                    :storage => :s3,
                    :bucket => ENV['WHITEBOARD_S3_BUCKET'],
                    :s3_credentials => {:access_key_id => ENV['WHITEBOARD_S3_KEY'],
                                        :secret_access_key => ENV['WHITEBOARD_S3_SECRET']},
                    :path => "deliverables/:course_year/:course_name/:random_hash/feedback/:id/:filename"

  default_scope :order => "created_at DESC"

  after_save :inaccurate_course_and_assignment_check

  def self.get_deliverables(course_id, faculty_id, options)

#    sql_template = "SELECT d.id FROM deliverables d INNER JOIN teams t ON d.team_id = t.id INNER JOIN team_assignments ta ON t.id = ta.team_id INNER JOIN users u1 ON d.creator_id = u1.id INNER JOIN users u2 ON ta.user_id = u2.id"
    sql_template = "SELECT d.id FROM deliverables d LEFT JOIN teams t ON d.team_id = t.id LEFT JOIN team_assignments ta ON t.id = ta.team_id LEFT JOIN users u1 ON d.creator_id = u1.id LEFT JOIN users u2 ON ta.user_id = u2.id"

    where_clause_course = " WHERE d.course_id = ?"

    where_clause_team_deliverable = " AND d.team_id IS NOT NULL AND t.primary_faculty_id = ?"

    where_clause_individual_deliverable = " AND d.team_id IS NULL AND d.creator_id IN (SELECT inner_ta.user_id FROM teams inner_t, team_assignments inner_ta WHERE inner_t.id = inner_ta.team_id AND inner_t.primary_faculty_id = ? AND course_id = ?)"

    where_clause_search = " AND (u1.first_name ILIKE ? OR u1.last_name ILIKE ? OR u1.human_name ILIKE ? OR u1.email ILIKE ? OR u1.webiso_account ILIKE ? OR u2.first_name ILIKE ? OR u2.last_name ILIKE ? OR u2.human_name ILIKE ? OR u2.email ILIKE ? OR u2.webiso_account ILIKE ? OR t.name ILIKE ?)"

    queue = []

    # 1. Are there teams in this course? If there are, and the "filter by teams is on", filter by teams
    # 2. If there are no teams in the course, and if this deliverable is an individual deliverable,
    # show deliverables for individuals who are in the faculty's teams only.
    # 3. Otherwise, show every deliverable

    course_has_teams = Team.where(:course_id => course_id).any?

    has_search_string = !options[:search_string].nil?
    selected_my_team = (options[:is_my_team] == 1)

    if has_search_string
      search_string = options[:search_string]
    end

    if !course_has_teams

      if has_search_string
        sql = sql_template + where_clause_course + where_clause_search
        deliverable_ids = Deliverable.find_by_sql([sql, course_id, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string]).uniq
      else
        sql = sql_template + where_clause_course
        deliverable_ids = Deliverable.find_by_sql([sql, course_id]).uniq
      end

    elsif selected_my_team

      if has_search_string
        sql = sql_template + where_clause_course + where_clause_team_deliverable + where_clause_search
        team_deliverable_ids = Deliverable.find_by_sql([sql, course_id, faculty_id, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string]).uniq

        sql = sql_template + where_clause_course + where_clause_individual_deliverable + where_clause_search
        individual_deliverable_ids = Deliverable.find_by_sql([sql, course_id, faculty_id, course_id, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string]).uniq
      else
        sql = sql_template + where_clause_course + where_clause_team_deliverable
        team_deliverable_ids = Deliverable.find_by_sql([sql, course_id, faculty_id]).uniq

        sql = sql_template + where_clause_course + where_clause_individual_deliverable
        individual_deliverable_ids = Deliverable.find_by_sql([sql, course_id, faculty_id, course_id]).uniq
      end

      deliverable_ids = []

      team_deliverable_ids.each do |team_deliverable_id|
        deliverable_ids << team_deliverable_id
      end

      individual_deliverable_ids.each do |individual_deliverable_id|
        deliverable_ids << individual_deliverable_id
      end

    else

      if has_search_string
        sql = sql_template + where_clause_course + where_clause_search
        deliverable_ids = Deliverable.find_by_sql([sql, course_id, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string, search_string]).uniq
      else
        sql = sql_template + where_clause_course
        deliverable_ids = Deliverable.find_by_sql([sql, course_id]).uniq
      end

    end

    deliverables = []

    deliverable_ids.each do |deliverable_id|
      deliverables << Deliverable.find(deliverable_id)
    end

    return deliverables

  end

  # To get the owner of the deliverable
  def unique_course_task_owner?
    if self.is_team_deliverable?
      duplicate = Deliverable.where(:course_id => self.course_id, :assignment_id => self.assignment_id, :team_id => self.team_id).first
      type = "team"
    else
      duplicate = Deliverable.where(:course_id => self.course_id, :assignment_id => self.assignment_id, :team_id => nil, :creator_id => self.creator_id).first
      type = "individual"
    end
    if duplicate && duplicate.id != self.id
      errors.add(:base, "Can't create another #{type} deliverable for the same course and task. Please edit the existing one.")
    end
  end

  # To check if it is a team deliverable
  def is_team_deliverable?
    self.is_team_deliverable
  end

  # To check the current attachment for the deliverable
  def current_attachment
    attachment_versions.first
  end

  # To get the name of the person/team who has submitted the deliverable
  def owner_name
    if self.is_team_deliverable?
      team.name unless team.blank? # 1/25/2014, why is it possible for team to be blank?
    else
      creator.human_name
    end
  end

  def owner_name_for_filename
    if self.is_team_deliverable?
      team.name
    else
      "#{creator.last_name} #{creator.first_name}"
    end
  end

  # To get the email_id/team_id who has submitted the deliverable
  def owner_email
    if self.is_team_deliverable?
      team.email
    else
      creator.email
    end
  end

  def self.find_current_by_user(user)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    current_teams = Team.find_current_by_person(user)
    Deliverable.find_by_user_and_teams(user, current_teams)
  end

  def self.find_past_by_user(user)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    past_teams = Team.find_past_by_person(user)
    Deliverable.find_by_user_and_teams(user, past_teams)
  end

  def self.find_by_user_and_teams(user, teams)
    team_condition = ""
    if !teams.empty?
      team_condition = "team_id IN ("
      team_condition << teams.collect { |t| t.id }.join(',')
      team_condition << ") OR "
    end
    Deliverable.find(:all, :conditions => team_condition + "(team_id IS NULL AND creator_id = #{user.id})")
  end

  # To see if this deliverable has a feedback or not
  def has_feedback?
    !self.feedback_comment.blank? or !self.feedback_file_name.blank?
  end

  # To send the deliverable submitted mail to the primary and secondary faculty
  def send_deliverable_upload_email(url)
    mail_to = []
    unless self.team.nil? || self.team.primary_faculty.nil?
      mail_to << self.team.primary_faculty.email
    end
    unless self.team.nil? || self.team.secondary_faculty.nil?
      mail_to << self.team.secondary_faculty.email
    end

    if mail_to.empty?
      return
    end

    message = self.owner_name + " has submitted a deliverable for "
    if !self.assignment.task_number.nil? and self.assignment.task_number != "" and !self.assignment.name.nil? and self.assignment.name !=""
      message += "#{self.assignment.name} (#{self.assignment.task_number}) of "
    end
    message += self.course.name

    options = {:to => mail_to,
               :subject => "Deliverable submitted for " + self.course.name + " by " + self.owner_name,
               :message => message,
               :url_label => "View this deliverable",
               :url => url
    }
    GenericMailer.email(options).deliver
  end

  # To send the feedback to the each student along with the score received respectively.
  def send_feedback_to_student(member_id, member_email, url, faculty_email=nil)
    feedback = "Feedback has been submitted for "
    if !self.assignment.task_number.nil? and self.assignment.task_number != "" and !self.assignment.name.nil? and self.assignment.name !=""
      feedback += "#{self.assignment.name} (#{self.assignment.task_number}) of "
    end
    feedback +=self.course.name

    if self.feedback_comment
      feedback +="\n\nFeedback Given:\n"
      feedback += self.feedback_comment
      feedback += "\n"
    end
    given_grade=Grade.get_grade(self.course.id, self.assignment_id, member_id)
    unless  given_grade.nil?
      feedback += "\nGrade earned for this "
      feedback += self.course.nomenclature_assignment_or_deliverable
      feedback += " is: "
      feedback += given_grade.score.to_s
      feedback+= " / "
      feedback += self.assignment.formatted_maximum_score
      feedback += "\n"
    end
    options = {:to => member_email,
               :cc => faculty_email,
               :subject => "Feedback for " + self.course.name,
               :message => feedback,
               :url_label => "View this deliverable",
               :url => url}

    GenericMailer.email(options).deliver
  end

  # To send the feedback in the email back to the students.
  def send_deliverable_feedback_email(url, faculty_email=nil)
    if self.is_team_deliverable?
      self.team.members.each do |member|
        send_feedback_to_student(member.id, member.email, url, faculty_email)
      end
    else
      send_feedback_to_student(self.creator_id, self.creator.email, url, faculty_email)
    end
  end

  # To check if the current user can change/edit the deliverable
  def editable?(current_user)
    return true if self.course.faculty_and_teaching_assistants.include?(current_user)

    if self.is_team_deliverable?
      unless self.team.is_user_on_team?(current_user)
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    if !self.is_team_deliverable?
      unless current_user == self.creator
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    return true
  end

  def update_team
    # Look up the team this user is on if it is a team deliverable
    Team.where(:course_id => self.course.id).each do |team|
      answer = team.members.include?(self.creator)
      self.team = team if team.members.include?(self.creator)
    end
  end

  # To check if the grade received for this deliverable is visible to the students or not.
  def is_visible_to_student?
    grade = Grade.get_grade(self.course.id, self.assignment.id, creator_id)
    grade.try(:is_student_visible) || false
#    grade_status == "graded"
  end

  # To update the feedback and the private notes by faculty
  def update_feedback_and_notes(params)
    self.feedback_comment = params[:feedback_comment]
    self.private_note = params[:private_note]
    unless params[:feedback].blank?
      self.feedback = params[:feedback]
    end
    if self.has_feedback?
      self.feedback_updated_at = Time.now
    end
    self.save
  end

  # To update the grade received by the student
  def update_grade(params, is_student_visible, current_user_id)
    error_msg = []
    if self.assignment.is_team_deliverable?
      self.team.members.each do |user|
        score = params[:"#{user.id}"]
        if Grade.give_grade(self.course_id, self.assignment.id, user.id, score, is_student_visible, current_user_id)==false
          error_msg << "Grade given to " + user.human_name + " is invalid!"
        end
      end
    else
      score = params[:"#{self.creator_id}"]
      unless Grade.give_grade(self.course_id, self.assignment.id, self.creator_id, score, is_student_visible, current_user_id)

        error_msg << "Grade given to " + self.creator.human_name + " is invalid!"
      end
    end
    error_msg
  end

  # Todo: update this when we are no longer using old data
  def assignment_name
    if self.assignment.nil?
      self.name
    else
      self.assignment.name
    end
  end

  # Todo: update this when we are no longer using old data
  def assignment_due_date
    if self.assignment
      self.assignment.due_date
    end
  end

  #Todo: rename get_grade_status to grade_status
  # To get the status of the deliverable for whether it is graded or not.
  def get_grade_status
    if self.is_team_deliverable?
      return :ungraded if self.team.nil?
      self.team.members.each do |member|
        status = self.get_status_for_every_individual(member.id)
        if status != :graded
          return status
        end
      end
      return :graded
    else
      return self.get_status_for_every_individual(self.creator_id)
    end
  end

  #Todo: rename get_status_for_every_individual to status_for_every_individual
  # To get the status of deliverable by student for is it graded or not.
  def get_status_for_every_individual(student_id)
    return :unknonwn if self.assignment.nil? #(guard for old deliverables)
    grade = Grade.get_grade(self.course.id, self.assignment.id, student_id)
    if grade.nil?
      return :ungraded
    elsif !grade.is_student_visible?
      return :drafted
    else
      return :graded
    end
  end


  def inaccurate_course_and_assignment_check
    if self.assignment
      if self.assignment.course_id != self.course_id
        options = {:to => "todd.sedano@sv.cmu.edu", :subject => "inaccurate_course_and_assignment_check #{self.id}",
                   :message => "The subject says it all", :url => "", :url_label => ""}
        GenericMailer.email(options).deliver
      end
    end
  end

  def get_graded_by
    if self.is_team_deliverable?
      return self.last_graded_by_for_every_individual(self.team.members[0].id)
    else
      return self.last_graded_by_for_every_individual(self.creator_id)
    end
  end

  def last_graded_by_for_every_individual(student_id)
    return :unknonwn if self.assignment.nil? #(guard for old deliverables)
    grade = Grade.get_grade(self.course.id, self.assignment.id, student_id)
    if grade.nil?
      return nil
    else
      return User.find_by_id(grade.last_graded_by) unless grade.last_graded_by.nil?
    end
  end

end
