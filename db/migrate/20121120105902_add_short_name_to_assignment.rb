class AddShortNameToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :short_name, :string 
  end

  def self.down
    remove_column :assignments, :short_name
  end
end
