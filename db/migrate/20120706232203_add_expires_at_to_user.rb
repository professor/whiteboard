class AddExpiresAtToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :expires_at, :date
    add_column :user_versions, :expires_at, :date
    add_index :users, :expires_at
  end

  def self.down
    remove_index :users, :expires_at
    remove_column :user_versions, :expires_at
    remove_column :users, :expires_at
  end
end
