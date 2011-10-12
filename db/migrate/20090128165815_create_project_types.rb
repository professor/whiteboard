class CreateProjectTypes < ActiveRecord::Migration
  def self.up
    create_table :project_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :project_types, :name
  end

  def self.down
    drop_table :project_types
  end
end
