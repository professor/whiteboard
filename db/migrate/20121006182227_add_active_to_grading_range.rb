class AddActiveToGradingRange < ActiveRecord::Migration
  def self.up
    add_column :grading_ranges, :active, :boolean
  end

  def self.down
    remove_column :grading_ranges, :active
  end
end
