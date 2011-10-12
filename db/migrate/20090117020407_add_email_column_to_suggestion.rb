class AddEmailColumnToSuggestion < ActiveRecord::Migration
  def self.up
    add_column :suggestions, :email, :string
#    Course.update_all("primary_faculty_label = 'Primary faculty'")
  end

  def self.down
    remove_column :suggestions, :email
  end
end
