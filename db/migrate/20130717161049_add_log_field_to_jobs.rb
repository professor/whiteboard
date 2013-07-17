class AddLogFieldToJobs < ActiveRecord::Migration
  def self.up
    add_column :jobs, :log, :text
  end

  def self.down
    remove_column :jobs, :log
  end
end
