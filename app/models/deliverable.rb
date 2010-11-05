class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :creator, :class_name => "Person"
  has_many :revisions, :class_name => "DeliverableRevision", :order => "submission_date DESC"
  # has_one :current_revision, :class_name => "DeliverableRevision", :order => 'submission_date DESC'

  validates_presence_of :course, :creator, :team

  has_attached_file :feedback,
    :storage => :s3,
    :s3_credentials => "#{RAILS_ROOT}/config/amazon_s3.yml",
    :path => "deliverable_feedback/super8/:id/:filename"

  def before_validation_on_create
    # Look up the team this person is on
    self.team = creator.teams.find(:first, :conditions => ['course_id = ?', course_id])
  end

  def current_revision
    revisions.find(:first)
  end

  def owner_name
    if self.is_team_deliverable?
      team.name
    else
      creator.human_name
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
    team_ids_string = ""
    team_condition = ""
    if !teams.empty?
      team_condition = "team_id IN ("
      team_condition << teams.collect{|t| t.id}.join(',')
      team_condition << ") OR "
    end
    Deliverable.find(:all, :conditions => team_condition + "(team_id IS NULL AND creator_id = #{person.id})")
  end

  def has_feedback?
    !(self.feedback_comment.nil? or self.feedback_comment == "") or !self.feedback_file_name.nil?
  end
end
