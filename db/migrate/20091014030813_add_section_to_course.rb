class AddSectionToCourse < ActiveRecord::Migration
  def self.up
    add_column :teams, :section, :string
  end

  def self.down
    remove_column :teams, :section
  end
end
