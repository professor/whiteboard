class CreateSponsoredProjectsPeoples < ActiveRecord::Migration
  def self.up
    create_table :sponsored_projects_peoples do |t|
      t.integer :sponsored_project_id
      t.integer :person_id
      t.integer :current_allocation

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsored_projects_peoples
  end
end
