class ChangeLearningObjectiveForPeerEvaluationToText < ActiveRecord::Migration
  def self.up
    change_column :peer_evaluation_learning_objectives, :learning_objective, :text

  end

  def self.down
    change_column :peer_evaluation_learning_objectives, :learning_objective, :string
  end
end
