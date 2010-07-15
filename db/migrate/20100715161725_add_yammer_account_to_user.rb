class AddYammerAccountToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :yammer_created, :timestamp
    add_column :user_versions, :yammer_created, :timestamp
  end

  def self.down
    remove_column :users, :yammer_created
    remove_column :user_versions, :yammer_created
  end
end
