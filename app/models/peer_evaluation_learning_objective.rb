class PeerEvaluationLearningObjective < ActiveRecord::Base
  validates_length_of :learning_objective, :maximum=>255
end
