class ConvertPersonIdToUserId < ActiveRecord::Migration
  def self.up
    rename_column :effort_logs, :person_id, :user_id
    rename_column :faculty_assignments, :person_id, :user_id
    rename_column :peer_evaluation_learning_objectives, :person_id, :user_id
    rename_column :sponsored_project_allocations, :person_id, :user_id
    rename_column :user_versions, :person_id, :user_id
    rename_column :teams_people, :person_id, :user_id
    rename_table :teams_people, :team_assignments
  end

  def self.down
    rename_table :team_assignments, :teams_people
    rename_column :teams_people, :user_id, :person_id
    rename_column :user_versions, :user_id, :person_id
    rename_column :sponsored_project_allocations, :user_id, :person_id
    rename_column :peer_evaluation_learning_objectives, :user_id, :person_id
    rename_column :faculty_assignments, :user_id, :person_id
    rename_column :effort_logs, :user_id, :person_id
  end
end
