class UpdateEffortLogForProjects < ActiveRecord::Migration
  def self.up
    remove_column :effort_log_line_items, :sub_task_type_id
    add_column :effort_log_line_items, :project_id, :integer
    drop_table :sub_task_types    
  end

  def self.down
    create_table :sub_task_types do |t|
      t.integer :task_type_id
      t.string :name
      t.string :description
      t.boolean :is_staff
      t.boolean :is_student

      t.timestamps
    end
    admin_id = TaskType.find_by_name("Administrative").id 
    SubTaskType.create :task_type_id => admin_id, :name => "Orientation / Gatherings", :description => "Time spent by core orientation project planning team", :is_staff => true, :is_student => false
    
    remove_column :effort_log_line_items, :project_id
    add_column :effort_log_line_items, :sub_task_type_id, :integer
  end
end
