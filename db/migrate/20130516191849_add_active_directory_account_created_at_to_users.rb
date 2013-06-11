class AddActiveDirectoryAccountCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_directory_account_created_at, :timestamp
    add_column :user_versions, :active_directory_account_created_at, :timestamp
  end

  def self.down
    remove_column :user_versions, :active_directory_account_created_at
    remove_column :users, :active_directory_account_created_at
  end
end
