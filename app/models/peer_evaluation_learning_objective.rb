class PeerEvaluationLearningObjective < ActiveRecord::Base
  attr_accessible 
  validates_length_of :learning_objective, :maximum => 255
end
