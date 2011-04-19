class AddPhotoToPerson < ActiveRecord::Migration
  def self.up
    [:users, :user_versions].each do |table|
      add_column table, :photo_file_name, :string
      add_column table, :photo_content_type, :string
    end
  end

  def self.down
    [:users, :user_versions].each do |table|
      remove_column table, :photo_content_type
      remove_column table, :photo_file_name
    end
  end
end
