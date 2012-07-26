class AddUserPreferencesForCourseIndex < ActiveRecord::Migration
  def self.up
    add_column :users,  :course_index_view, :string
    add_column :user_versions, :course_index_view, :string
  end

  def self.down
    remove_column :users, :course_index_view
    remove_column :user_versions,  :course_index_view
  end
end

