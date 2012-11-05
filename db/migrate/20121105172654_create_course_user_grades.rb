class CreateCourseUserGrades < ActiveRecord::Migration
  def self.up
    create_table :course_user_grades do |t|
      t.integer :user_id
      t.integer :course_id
      t.string :grade

      t.timestamps
    end

    add_index :course_user_grades, :user_id
    add_index :course_user_grades, :course_id
  end

  def self.down
    remove_index :course_user_grades, :user_id
    remove_index :course_user_grades, :course_id
    drop_table :course_user_grades
  end
end
