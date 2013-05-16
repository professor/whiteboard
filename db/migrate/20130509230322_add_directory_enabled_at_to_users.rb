class AddDirectoryEnabledAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :directory_enabled_at, :timestamp
  end

  def self.down
    remove_column :users, :directory_enabled_at
  end
end
