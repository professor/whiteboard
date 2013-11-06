class PeerEvaluationLearningObjective < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_length_of :learning_objective, :maximum => 255
end
