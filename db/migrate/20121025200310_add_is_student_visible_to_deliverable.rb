class AddIsStudentVisibleToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :is_student_visible, :boolean
  end

  def self.down
    remove_column :deliverables, :is_student_visible
  end
end
