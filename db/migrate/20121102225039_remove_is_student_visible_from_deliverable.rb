class RemoveIsStudentVisibleFromDeliverable < ActiveRecord::Migration
  def self.up
    remove_column :deliverables ,:is_student_visible
  end

  def self.down
    add_column :deliverables, :is_student_visible ,:boolean
  end
end
