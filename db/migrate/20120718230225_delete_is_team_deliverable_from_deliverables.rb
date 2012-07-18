class DeleteIsTeamDeliverableFromDeliverables < ActiveRecord::Migration
  def self.up
    remove_column :deliverables, :is_team_deliverable
  end

  def self.down
    add_column :deliverables, :is_team_deliverable, :integer
  end
end
