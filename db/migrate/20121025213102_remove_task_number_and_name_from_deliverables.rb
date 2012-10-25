class RemoveTaskNumberAndNameFromDeliverables < ActiveRecord::Migration
  def self.up
    remove_column :deliverables, :task_number
    remove_column :deliverables, :name
  end

  def self.down
    add_column :deliverables, :task_number, :string
#    add_column :deliverable, :name, :string
  end
end
