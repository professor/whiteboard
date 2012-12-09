class RemoveUnneededCourseConfigurationFields < ActiveRecord::Migration
  def self.up
    remove_column :courses, :configure_class_mailinglist
    remove_column :courses, :configure_teams_name_themselves

  end

  def self.down
    add_column :courses, :configure_class_mailinglist, :boolean, :default => false
    add_column :courses, :configure_teams_name_themselves, :boolean, :default => true
  end
end
