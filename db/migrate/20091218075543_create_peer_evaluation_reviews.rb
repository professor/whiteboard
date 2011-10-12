class CreatePeerEvaluationReviews < ActiveRecord::Migration
  def self.up
    create_table :peer_evaluation_reviews do |t|
      t.integer :team_id
      t.integer :author_id
      t.integer :recipient_id
      t.string :question
      t.string :answer
      t.integer :sequence_number

      t.timestamps
    end
  end

  def self.down
    drop_table :peer_evaluation_reviews
  end
end
