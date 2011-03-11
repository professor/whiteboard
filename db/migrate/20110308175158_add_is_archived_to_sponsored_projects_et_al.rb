class AddIsArchivedToSponsoredProjectsEtAl < ActiveRecord::Migration
  def self.up
    add_column :sponsored_project_allocation, :is_archived, :boolean, :default => false
    add_column :sponsored_project_sponsors, :is_archived, :boolean, :default => false
    add_column :sponsored_projects, :is_archived, :boolean, :default => false

    add_index :sponsored_project_allocation, :is_archived
    add_index :sponsored_project_sponsors, :is_archived
    add_index :sponsored_projects, :is_archived

  end

  def self.down
    remove_index :sponsored_projects, :is_archived
    remove_index :sponsored_project_sponsors, :is_archived
    remove_index :sponsored_project_allocation, :is_archived

    remove_column :sponsored_projects, :is_archived
    remove_column :sponsored_project_sponsors, :is_archived
    remove_column :sponsored_project_allocation, :is_archived
  end
end
