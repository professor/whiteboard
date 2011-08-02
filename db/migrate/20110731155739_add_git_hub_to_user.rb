class AddGitHubToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :github, :string
    add_column :user_versions, :github, :string
  end

  def self.down
    remove_column :user_versions, :github
    remove_column :users, :github
  end
end
