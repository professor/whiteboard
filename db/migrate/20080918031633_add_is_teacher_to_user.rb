class AddIsTeacherToUser < ActiveRecord::Migration

  def self.up
    add_column :users, :is_teacher, :boolean
    add_column :users, :is_adobe_connect_host, :boolean
  end

  def self.down
    remove_column :users, :is_teacher
    remove_column :users, :is_adobe_connect_host
  end

end
