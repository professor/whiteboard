class AddActiveDirectoryAccountCreatedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active_directory_account_created_at, :timestamp
  end

  def self.down
    remove_column :users, :active_directory_account_created_at
  end
end
