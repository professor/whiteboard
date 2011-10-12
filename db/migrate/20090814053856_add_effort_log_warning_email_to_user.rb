class AddEffortLogWarningEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :effort_log_warning_email, :datetime
  end

  def self.down
    remove_column :users, :effort_log_warning_email
  end
end
