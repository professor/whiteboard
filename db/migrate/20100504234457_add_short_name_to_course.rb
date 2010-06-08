class AddShortNameToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :short_name, :string
    add_column :course_numbers, :short_name, :string
  end

  def self.down
    remove_column :course_numbers, :short_name
    remove_column :courses, :short_name
  end
end
