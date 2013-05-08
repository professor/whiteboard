class AddUriToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :image_uri_first, :string, :default => "/images/mascot.jpg"
    add_column :users, :image_uri_second, :string, :default => "/images/mascot.jpg"
    add_column :users, :image_uri_custom, :string, :default => "/images/mascot.jpg"

    add_column :users, :photo_first_file_name, :string
    add_column :users, :photo_first_content_type, :string
    add_column :users, :photo_second_file_name, :string
    add_column :users, :photo_second_content_type, :string
    add_column :users, :photo_custom_file_name, :string
    add_column :users, :photo_custom_content_type, :string
    add_column :users, :photo_selection, :string

    add_column :user_versions, :image_uri_first, :string
    add_column :user_versions, :image_uri_second, :string
    add_column :user_versions, :image_uri_custom, :string

    add_column :user_versions, :photo_first_file_name, :string
    add_column :user_versions, :photo_first_content_type, :string
    add_column :user_versions, :photo_second_file_name, :string
    add_column :user_versions, :photo_second_content_type, :string
    add_column :user_versions, :photo_custom_file_name, :string
    add_column :user_versions, :photo_custom_content_type, :string
    add_column :user_versions, :photo_selection, :string

    User.connection.execute("update users set image_uri_first=image_uri")
    User.connection.execute("update users set image_uri_second='/images/mascot.jpg'")
    User.connection.execute("update users set image_uri_custom='/images/mascot.jpg'")
    User.connection.execute("update users set photo_selection='first'")
  end

  def self.down
    remove_column :users, :image_uri_first
    remove_column :users, :image_uri_second
    remove_column :users, :image_uri_custom
    remove_column :user_versions, :image_uri_first
    remove_column :user_versions, :image_uri_second
    remove_column :user_versions, :image_uri_custom

    remove_column :users, :photo_first_file_name
    remove_column :users, :photo_first_content_type
    remove_column :users, :photo_second_file_name
    remove_column :users, :photo_second_content_type
    remove_column :users, :photo_custom_file_name
    remove_column :users, :photo_custom_content_type
    remove_column :users, :photo_selection

    remove_column :user_versions, :photo_first_file_name
    remove_column :user_versions, :photo_first_content_type
    remove_column :user_versions, :photo_second_file_name
    remove_column :user_versions, :photo_second_content_type
    remove_column :user_versions, :photo_custom_file_name
    remove_column :user_versions, :photo_custom_content_type
    remove_column :user_versions, :photo_selection
  end
end
