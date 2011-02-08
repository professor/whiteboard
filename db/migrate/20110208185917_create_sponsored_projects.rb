class CreateSponsoredProjects < ActiveRecord::Migration
  def self.up
    create_table :sponsored_projects do |t|
      t.string :name
      t.integer :sponsor_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsored_projects
  end
end
