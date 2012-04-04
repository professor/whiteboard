class RemoveProjectsAndProjectTypes < ActiveRecord::Migration

  def self.up
    drop_table :projects
    drop_table :project_types
    remove_column :effort_log_line_items, :project_id

  end

  def self.down
    add_column :effort_log_line_items, :project_id, :integer

    create_table :projects do |t|
      t.string :name
      t.integer :project_type_id
      t.integer :course_id
      t.boolean :is_closed

      t.timestamps
    end

    create_table :project_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end

    add_index :projects, :name
    add_index :project_types, :name

  end

end
