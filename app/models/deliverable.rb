class Deliverable < ActiveRecord::Base
  belongs_to :team
  belongs_to :course
  belongs_to :creator, :class_name => "Person"
  has_one :current_revision, :class_name => "DeliverableRevision"
  has_many :revisions, :class_name => "DeliverableRevision"

  validates_presence_of :course, :creator, :current_revision  

  def before_save
    # Look up the team this person is on
    self.team = creator.teams.find(:first, :conditions => ['course_id = ?', course_id])
  end

  def owner_name
    if self.is_team_deliverable?
      team.name
    else
      creator.human_name
    end
  end
  
end
