class CreateSponsoredProjectsEfforts < ActiveRecord::Migration
  def self.up
    create_table :sponsored_project_efforts do |t|
      t.integer :sponsored_projects_people_id
      t.integer :year
      t.integer :month
      t.integer :actual_allocation
      t.integer :current_allocation
      t.boolean :confirmed

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsored_project_efforts
  end
end
