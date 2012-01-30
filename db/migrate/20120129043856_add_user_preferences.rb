class AddUserPreferences < ActiveRecord::Migration
  def self.up
    add_column :users,  :course_tools_view, :string
    add_column :user_versions, :course_tools_view, :string
  end

  def self.down
    remove_column :users, :course_tools_view
    remove_column :user_versions,  :course_tools_view
  end
end
