class CreateAssignmentGrades < ActiveRecord::Migration
  def self.up
    create_table :assignment_grades do |t|
      t.integer :user_id
      t.integer :assignment_id
      t.string :given_grade

      t.timestamps
    end

    add_index :assignment_grades, :user_id
    add_index :assignment_grades, :assignment_id
  end

  def self.down
    remove_index :assignment_grades, :assignment_id
    remove_index :assignment_grades, :user_id
    drop_table :assignment_grades
  end
end
