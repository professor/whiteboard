class CreateTaskTypes < ActiveRecord::Migration
  def self.up
    create_table :task_types do |t|
      t.string :name
      t.string :description
      t.boolean :is_staff,     :default => false
      t.boolean :is_student,   :default => false

      t.timestamps
    end
    
    #TaskType.create :is_student => true, :name => "Work on Deliverables", :description => "Time spent on creating deliverables both as an individual and in team working meeting."
    #TaskType.create :is_student => true, :name => "Readings", :description => "Time spent researching and reading for the course. "
    #TaskType.create :is_student => true, :name => "Meetings", :description => "Time spent in plenary sessions and team status meetings."
    #TaskType.create :is_student => true, :name => "Other", :description => "Any time spent on course-related activities that is not included in the above categories."
    #
    #TaskType.create :is_staff => true, :name => "Administrative", :description => ""
    #TaskType.create :is_staff => true, :name => "Teaching - Delivery", :description => ""
    #TaskType.create :is_staff => true, :name => "Teaching - Development", :description => ""
    #TaskType.create :is_staff => true, :name => "Student Supervision", :description => ""
    #TaskType.create :is_staff => true, :name => "Research", :description => ""
    #TaskType.create :is_staff => true, :name => "Marketing/Admissions", :description => ""
    #TaskType.create :is_staff => true, :name => "Outreach", :description => ""
    
  end

  def self.down
    drop_table :task_types
  end
end
