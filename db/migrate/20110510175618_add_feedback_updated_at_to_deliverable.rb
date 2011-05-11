class AddFeedbackUpdatedAtToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :feedback_updated_at, :timestamp
  end

  def self.down
    remove_column :deliverables, :feedback_updated_at, :timestamp
  end
end
