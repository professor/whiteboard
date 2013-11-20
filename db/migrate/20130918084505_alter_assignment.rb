class AlterAssignment < ActiveRecord::Migration
  def self.up
      change_column_default :assignments, :is_submittable, true
      change_column_default :assignments, :is_team_deliverable, false
  end
  
  def self.down
      change_column_default :assignments, :is_submittable, nil
      change_column_default :assignments, :is_team_deliverable, nil
  end
end
