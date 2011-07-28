class AlterPeerEvaluation < ActiveRecord::Migration
  def self.up
    change_column(:teams, :peer_evaluation_first_email, :date)
    change_column(:teams, :peer_evaluation_second_email, :date)
  end

  def self.down
    change_column(:teams, :peer_evaluation_first_email, :datetime)
    change_column(:teams, :peer_evaluation_second_email, :datetime)
  end
end
