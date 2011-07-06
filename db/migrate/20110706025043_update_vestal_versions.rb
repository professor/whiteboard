class UpdateVestalVersions < ActiveRecord::Migration
  def self.up
    rename_column :versions, :changes, :modifications
    add_column :versions, :reverted_from, :integer
  end

  def self.down
    remove_column :versions, :reverted_from
    rename_column :versions, :modifications, :changes
  end
end




