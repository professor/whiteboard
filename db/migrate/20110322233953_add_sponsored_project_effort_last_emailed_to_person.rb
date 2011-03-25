class AddSponsoredProjectEffortLastEmailedToPerson < ActiveRecord::Migration
  def self.up
    add_column :users, :sponsored_project_effort_last_emailed, :datetime
    add_column :user_versions, :sponsored_project_effort_last_emailed, :datetime
  end

  def self.down
    remove_column :user_versions, :sponsored_project_effort_last_emailed
    remove_column :users, :sponsored_project_effort_last_emailed
  end
end
