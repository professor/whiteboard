class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :creator, :class_name => "Person"
  has_many :revisions, :class_name => "DeliverableRevision", :order => "submission_date DESC"
  # has_one :current_revision, :class_name => "DeliverableRevision", :order => 'submission_date DESC'

  validates_presence_of :course, :creator, :team

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

end
