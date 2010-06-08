class PagesRenameCourseNumberIdToCourseId < ActiveRecord::Migration
  def self.up
    rename_column :pages, :course_number_id, :course_id
    add_index :pages, :position
    add_index :pages, :course_id
  end

  def self.down
    remove_index :pages, :course_id
    remove_index :pages, :position
    rename_column :pages, :course_id, :course_number_id
  end
end
