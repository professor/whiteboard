class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :creator, :class_name => "Person"
  has_many :attachment_versions, :class_name => "DeliverableAttachment", :order => "submission_date DESC"

  validates_presence_of :course, :creator

  has_attached_file :feedback,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
    :path => "deliverables/:course_year/:course_name/:random_hash/feedback/:id/:filename"

  default_scope :order => "updated_at DESC"

  def before_validation
    # Look up the team this person is on if it is a team deliverable
    self.team = creator.teams.find(:first, :conditions => ['course_id = ?', course_id]) if self.is_team_deliverable
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
      team_condition << teams.collect{|t| t.id}.join(',')
      team_condition << ") OR "
    end
    Deliverable.find(:all, :conditions => team_condition + "(team_id IS NULL AND creator_id = #{person.id})")
  end

  def has_feedback?
    !self.feedback_comment.blank? or !self.feedback_file_name.blank?
  end
end
