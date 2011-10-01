class AddSumTotalToEffortLog < ActiveRecord::Migration
  def self.up
    add_column :effort_logs, :sum, :float
  end

  def self.down
    remove_column :effort_logs, :sum
  end
end
