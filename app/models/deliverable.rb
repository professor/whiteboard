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

  before_validation :update_team, :sanitize_data


  def unique_course_task_owner?
    if self.is_team_deliverable?
      duplicate = Deliverable.where(:course_id => self.course_id, :task_number => self.task_number, :is_team_deliverable => true, :team_id => self.team_id).first
    else
      duplicate = Deliverable.where(:course_id => self.course_id, :task_number => self.task_number, :is_team_deliverable => false, :creator_id => self.creator_id).first
    end
    if duplicate && duplicate.id != self.id
      errors.add(:base, "Can't create another deliverable for the same course and task. Please edit the existing one.")
    end
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

#      team_condition = "(team_id IN ("
#      team_condition << teams.collect{|t| t.id}.join(',')
#      team_condition << "AND is_team_deliverable = 0) OR "
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
    self.team = creator.teams.find(:first, :conditions => ['course_id = ?', course_id]) if self.is_team_deliverable?
  end

  def sanitize_data
    self.name = self.name.titleize unless self.name.blank?
  end


end
