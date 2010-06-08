class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string :name
      t.integer :project_type_id
      t.integer :course_id
      t.boolean :is_closed

      t.timestamps
    end
    
    add_index :projects, :name

  end

  def self.down
    drop_table :projects
  end
end
