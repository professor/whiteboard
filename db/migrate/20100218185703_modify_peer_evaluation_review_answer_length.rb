class ModifyPeerEvaluationReviewAnswerLength < ActiveRecord::Migration
  def self.up
    change_column :peer_evaluation_reviews, :answer, :text
  end

  def self.down
    change_column :peer_evaluation_reviews, :answer, :string
  end
end
