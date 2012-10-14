class SetDefaultValueForAssignment < ActiveRecord::Migration
  def self.up
    change_column :assignments, :is_submittable, :boolean, :default=>false
    change_column :assignments, :is_team_deliverable, :boolean, :default=>false
  end

  def self.down
    change_column :assignments, :is_submittable, :boolean
    change_column :assignments, :is_team_deliverable, :boolean 
  end
end
