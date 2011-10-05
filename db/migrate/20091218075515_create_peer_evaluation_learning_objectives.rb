class CreatePeerEvaluationLearningObjectives < ActiveRecord::Migration
  def self.up
    create_table :peer_evaluation_learning_objectives do |t|
      t.integer :person_id
      t.integer :team_id
      t.string :learning_objective

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_evaluation_learning_objectives
  end
end
