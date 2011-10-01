class CreateSubTaskTypes < ActiveRecord::Migration
  def self.up
    create_table :sub_task_types do |t|
      t.integer :task_type_id
      t.string :name
      t.string :description
      t.boolean :is_staff
      t.boolean :is_student

      t.timestamps
    end
    #admin_id = TaskType.find_by_name("Administrative").id
    #SubTaskType.create :task_type_id => admin_id, :name => "Orientation / Gatherings", :description => "Time spent by core orientation project planning team", :is_staff => true, :is_student => false
  end

  def self.down
    drop_table :sub_task_types
  end
end
