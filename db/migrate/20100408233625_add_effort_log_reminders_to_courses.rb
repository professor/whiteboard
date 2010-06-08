class AddEffortLogRemindersToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :remind_about_effort, :boolean
  end

  def self.down
    remove_column :courses, :remind_about_effort
  end
end
