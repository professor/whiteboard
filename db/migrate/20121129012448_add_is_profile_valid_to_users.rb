class AddIsProfileValidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_profile_valid, :boolean
    add_column :user_versions, :is_profile_valid, :boolean
  end

  def self.down
    remove_column :users, :is_profile_valid
    remove_column :user_versions, :is_profile_valid
  end
end
