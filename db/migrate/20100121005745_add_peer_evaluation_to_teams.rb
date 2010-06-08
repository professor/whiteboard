class AddPeerEvaluationToTeams < ActiveRecord::Migration
  def self.up
      add_column :teams, :peer_evaluation_first_email, :datetime
      add_column :teams, :peer_evaluation_second_email, :datetime
      add_column :teams, :peer_evaluation_do_point_allocation, :boolean
  end

  def self.down
  end
end
