class AddAssignmentIdToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :assignment_id, :integer
    add_index :deliverables, :assignment_id
    remove_column :deliverables, :course_id
    remove_column :deliverables, :task_number
  end

  def self.down
    add_column :deliverables, :task_number, :string
    add_column :deliverables, :course_id, :integer
    remove_index :deliverables, :assignment_id
    remove_column :deliverables, :assignment_id
  end
end
