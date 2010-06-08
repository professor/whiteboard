class CreateProjectTypes < ActiveRecord::Migration
  def self.up
    create_table :project_types do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
    add_index :project_types, :name
    
    
    ProjectType.create :name => "Administrative"
    ProjectType.create :name => "Teaching - Delivery"
    ProjectType.create :name => "Teaching - Development"
    ProjectType.create :name => "Student Supervision"
    ProjectType.create :name => "Research"
    ProjectType.create :name => "Marketing & Admissions"
    ProjectType.create :name => "Outreach"    
    
  end

  def self.down
    drop_table :project_types
  end
end
