class RemoveNameFromDeliverables < ActiveRecord::Migration
  def self.up
    remove_column :deliverables, :name
  end

  def self.down
    add_column :deliverables, :name, :string
  end
end
