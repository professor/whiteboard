class CreateGradeBooks < ActiveRecord::Migration
  def self.up
    create_table :grade_books do |t|
      t.integer :course_id
      t.integer :student_id
      t.integer :assignment_id
      t.float :score

      t.timestamps
    end
  end

  def self.down
    drop_table :grade_books
  end
end
