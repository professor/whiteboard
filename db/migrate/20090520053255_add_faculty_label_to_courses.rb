class AddFacultyLabelToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :primary_faculty_label, :string
    add_column :courses, :secondary_faculty_label, :string
    
    #Course.update_all("primary_faculty_label = 'Primary faculty'")
    #Course.update_all("secondary_faculty_label = ''")
  end

  def self.down
    remove_column :courses, :primary_faculty_label
    remove_column :courses, :secondary_faculty_label
  end
end
