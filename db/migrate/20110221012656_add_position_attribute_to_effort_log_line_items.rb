class AddPositionAttributeToEffortLogLineItems < ActiveRecord::Migration
  def self.up
    add_column :effort_log_line_items, :position, :integer
  end

  def self.down
    remove_column :effort_log_line_items, :position
  end
end
