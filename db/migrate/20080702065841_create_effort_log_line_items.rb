class CreateEffortLogLineItems < ActiveRecord::Migration
  def self.up
    create_table :effort_log_line_items do |t|
      t.integer :effort_log_id
      t.integer :course_id
      t.integer :task_type_id
      t.integer :sub_task_type_id
      t.float :day1
      t.float :day2
      t.float :day3
      t.float :day4
      t.float :day5
      t.float :day6
      t.float :day7
      t.float :sum
      
      t.timestamps
    end
  end

  def self.down
    drop_table :effort_log_line_items
  end
end
