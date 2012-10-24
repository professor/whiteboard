class RemoveScoreFromDeliverable < ActiveRecord::Migration
  def self.up
    remove_column :deliverables, :score
  end

  def self.down
    add_column :deliverales, :score, :integer
  end
end
