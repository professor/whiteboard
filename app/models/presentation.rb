class Presentation < ActiveRecord::Base
  belongs_to :team
  belongs_to :user, :class_name => "Person"
  belongs_to :creator, :class_name => "Person"
  has_many :presentation_feedbacks
  has_attached_file :presentation,
                      :storage => :s3,
                      :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                      :path => "presentation/:id/:filename"

  validates :team_id, :presence => {:unless => "user_id", :message => "You must select a team or user"}
  validates_presence_of :name, :creator, :presentation_file_name
  validate :team_xor_user

  default_scope :order => "updated_at DESC"

  def to_s
    name
  end

  def is_team_presentation?
    !self.team.blank?
  end

  def self.find_by_person(person)
    # Find everything where the passed in person is either the assignee
    # or is on the presentation's team
    teams = Team.find_by_person(person)
    Presentation.find_by_person_and_teams(person, teams)
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
    Presentation.where(team_condition + "(team_id IS NULL AND user_id = #{person.id})")
  end

  def editable?(user)
    (self.creator_id == user.id || user.is_admin?)
  end

  def hasGivenFeedback?(user)
    @presentation_feedbacks = PresentationFeedback.where("user_id = :uid AND presentation_id = :pid",
          {:uid => user.id, :pid => self.id})

    if @presentation_feedbacks[0] == nil
      return false
    else
      return true
    end
  end

  def canViewFeedback?(user)
    if user == self.user || user.is_teacher? || user.is_admin
      return true
    end
    return false
  end

  private

  def team_xor_user
    if !(team_id.blank? ^ user_id.blank?)
      errors.add("team_id","Specify a team or a user, not both")
    end
  end
end
