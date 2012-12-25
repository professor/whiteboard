class AddSocialHandlesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :linked_in, :string
    add_column :users, :facebook, :string
    add_column :users, :twitter, :string
    add_column :users, :google_plus, :string

    add_column :user_versions, :linked_in, :string
    add_column :user_versions, :facebook, :string
    add_column :user_versions, :twitter, :string
    add_column :user_versions, :google_plus, :string

  end

  def self.down
    remove_column :users, :linked_in
    remove_column :users, :facebook
    remove_column :users, :twitter
    remove_column :users, :google_plus

    remove_column :user_versions, :linked_in
    remove_column :user_versions, :facebook
    remove_column :user_versions, :twitter
    remove_column :user_versions, :google_plus
  end
end