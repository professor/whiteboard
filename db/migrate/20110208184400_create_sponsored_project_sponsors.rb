class CreateSponsoredProjectSponsors < ActiveRecord::Migration
  def self.up
    create_table :sponsored_project_sponsors do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsored_project_sponsors
  end
end
