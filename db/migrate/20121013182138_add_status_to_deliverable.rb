class AddStatusToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :status, :string
  end

  def self.down
    remove_column :deliverables, :status, :string
  end
end
