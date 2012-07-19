class RemoveLoginFromUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :login
    remove_column :user_versions, :login
  end

  def self.down
    add_column :users, :login, :string, :limit => 40
    add_column :user_versions, :login, :string, :limit => 40
  end
end
