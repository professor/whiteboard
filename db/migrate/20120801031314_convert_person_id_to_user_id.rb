class ConvertPersonIdToUserId < ActiveRecord::Migration
  def self.up
    rename_column :effort_logs, :person_id, :user_id
  end

  def self.down
    rename_column :effort_logs, :user_id, :person_id
  end
end
