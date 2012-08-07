# Peer Evaluations are done by student teams at the request of a faculty member.
# Usually, the faculty member will setup the peer evaluation and will need to
# know the following information
# * Start date - when to email the student team about the evaluation.
#   Teams can start before this
# * End date - when to email the student team
#   Teams can end after this provided the faculty hasn't created the report.
# * Learning Ojbectives for each team member (optional)
#
# == Related classes
# {Peer Evaluation Controller}[link:classes/PeerEvaluationController.html]
#
# {Peer Evaluation Learning Objective}[link:classes/PeerEvaluationLearningObjective.html]
#
# {Peer Evaluation Report}[link:classes/PeerEvaluationReport.html]
#
# == Assumptions
# * The peer evaluation for a team is always ready, theoretically a team could
#   start one on their own
# * A team would not need to do a peer evaluation twice. If they had to,
#   a system admin would clean out the data or alter the foreign keys to appear
#   as if a peer evaluation had not been done for that team
# == Security
# * Students should not be able to see the peer evaluations for other students
# * Any faculty can see the peer evaluation for a team
#
# This component was originally written by Russel Reed (Class of 2010)
# and integrated by Todd Sedano. Student teams can provide 360 review feedback
# when prompted by the faculty.
class PeerEvaluationReview < ActiveRecord::Base

  belongs_to :team
  belongs_to :author, :class_name => "User"
  belongs_to :recipient, :class_name => "User"

  def self.is_completed_for?(user_id, team_id)
    !PeerEvaluationReview.where({:team_id => team_id, :author_id => user_id}).empty?
  end


end
