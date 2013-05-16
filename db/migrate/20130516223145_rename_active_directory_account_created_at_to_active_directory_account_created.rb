class RenameActiveDirectoryAccountCreatedAtToActiveDirectoryAccountCreated < ActiveRecord::Migration
  def self.up
    remove_column :users, :active_directory_account_created_at
    add_column :users, :active_directory_account_created, :timestamp
  end

  def self.down
    remove_column :users, :active_directory_account_created
    add_column :users, :active_directory_account_created_at, :timestamp
  end
end
