class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.integer :task_number
      t.string :title
      t.boolean :team_deliverable
      t.datetime :due_date
      t.integer :max_score
      t.integer :weight
      t.boolean :can_submit
      t.integer :course_id

      t.timestamps
    end

    add_index :assignments, :course_id
  end

  def self.down
    remove_index :assignments, :course_id
    drop_table :assignments
  end
end
