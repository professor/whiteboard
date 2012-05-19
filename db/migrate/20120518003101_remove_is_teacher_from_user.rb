class RemoveIsTeacherFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :is_teacher
    remove_column :user_versions, :is_teacher
  end

  def self.down
    add_column :users, :is_teacher, :boolean
    add_column :user_versions, :is_teacher, :boolean
  end
end
