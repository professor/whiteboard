class AddPermissionToGradeBooks < ActiveRecord::Migration
  def self.up
    add_column :grade_books, :is_student_visible, :boolean
  end

  def self.down
    remove_column :grade_books, :is_student_visible
  end
end
