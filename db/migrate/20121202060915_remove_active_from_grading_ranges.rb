class RemoveActiveFromGradingRanges < ActiveRecord::Migration
  def self.up
    remove_column :grading_ranges, :active
  end

  def self.down
    add_column :grading_ranges, :active, :boolean
  end
end