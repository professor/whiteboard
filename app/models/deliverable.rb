# Deliverable is a zip or a file that the students submit for a course
#
# There are two ways for a student team to upload their deliverables.
#
# Way 1) On the curriculum pages for each task,  under the "Submitting Your Work" tab, there is a
# "submit your deliverable link" -- this gives the student the ability to name their deliverable, and upload a
# single attachment (i.e. one doc, ppt, or zip file) The student needs to mark whether this is an individual deliverable
# or team deliverable. By default a task number and the course number is provided for the student.
# If a faculty member tries to do this, they won't see any courses lists since they aren't taking the course as a student.
# Students can submit only team deliverable and one individual deliverable per task, although they can update the
# attachment as many times as they like.
#
# Every member of a team can see team deliverables, only the individual can see their individual deliverable.
#
# Way 2) A student team can upload their deliverable by clicking on "My Deliverables" on the left hand navigation and
# select "New" at the bottom of the page. This is a little less efficient because the student needs to select a
# course and task number. It is a quick way for a student to see everything they have submitted for their courses.
#
## If a student or team accidentally uploads the wrong file, they can upload additional files. All files are
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
  belongs_to :creator, :class_name => "Person"
  has_many :attachment_versions, :class_name => "DeliverableAttachment", :order => "submission_date DESC"

  validates_presence_of :course, :creator
  validate :unique_course_task_owner?

  has_attached_file :feedback,
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :path => "deliverables/:course_year/:course_name/:random_hash/feedback/:id/:filename"

  default_scope :order => "updated_at DESC"

  before_validation :sanitize_data


  def unique_course_task_owner?
    if self.is_team_deliverable?
      duplicate = Deliverable.where(:course_id => self.course_id, :task_number => self.task_number, :team_id => self.team_id).first
    else
      duplicate = Deliverable.where(:course_id => self.course_id, :task_number => self.task_number, :creator_id => self.creator_id).first
    end
    if duplicate && duplicate.id != self.id
      errors.add(:base, "Can't create another deliverable for the same course and task. Please edit the existing one.")
    end
  end

  def is_team_deliverable?
    team ? true : false
  end

  def current_attachment
    attachment_versions.find(:first)
  end

  def owner_name
    if self.is_team_deliverable?
      team.name
    else
      creator.human_name
    end
  end

  def owner_email
    if self.is_team_deliverable?
      team.email
    else
      creator.email
    end
  end

  def self.find_current_by_person(person)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    current_teams = Team.find_current_by_person(person)
    Deliverable.find_by_person_and_teams(person, current_teams)
  end

  def self.find_past_by_person(person)
    # Find everything where the passed in person is either the creator
    # or is on the deliverable's team
    past_teams = Team.find_past_by_person(person)
    Deliverable.find_by_person_and_teams(person, past_teams)
  end

  def self.find_by_person_and_teams(person, teams)
    team_condition = ""
    if !teams.empty?
      team_condition = "team_id IN ("
      team_condition << teams.collect { |t| t.id }.join(',')
      team_condition << ") OR "
    end
    Deliverable.find(:all, :conditions => team_condition + "(team_id IS NULL AND creator_id = #{person.id})")
  end

  def has_feedback?
    !self.feedback_comment.blank? or !self.feedback_file_name.blank?
  end


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
    if !self.task_number.nil? and self.task_number != ""
      message += "task " + self.task_number + " of "
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

  def send_deliverable_feedback_email(url)
    mail_to = self.owner_email

    message = "Feedback has been submitted for "
    if !self.task_number.nil? and self.task_number != ""
      message += "task " + self.task_number + " of "
    end
    message += self.course.name

    options = {:to => mail_to,
               :subject => "Feedback for " + self.course.name,
               :message => message,
               :url_label => "View this deliverable",
               :url => url
    }
    GenericMailer.email(options).deliver
  end

  def editable?(current_user)
    person = Person.find(current_user.id)
    if self.is_team_deliverable?
      unless self.team.is_person_on_team?(person)
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    if !self.is_team_deliverable?
      unless person == self.creator
        unless (current_user.is_staff?)||(current_user.is_admin?)
          return false
        end
      end
    end
    return true
  end


  protected
  def update_team
    # Look up the team this person is on if it is a team deliverable
    self.team = creator.teams.find(:first, :conditions => ['course_id = ?', course_id])
  end

  def sanitize_data
    self.name = self.name.titleize unless self.name.blank?
  end


end
