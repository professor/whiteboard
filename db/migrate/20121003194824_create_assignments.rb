class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.string :name
      t.float :maximum_score
      t.boolean :is_team_deliverable
      t.datetime :due_date
      t.integer :course_id
      t.integer :assignment_order
      t.integer :task_number
      t.boolean :is_submittable

      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
