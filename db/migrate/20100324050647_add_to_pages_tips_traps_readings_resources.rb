class AddToPagesTipsTrapsReadingsResources < ActiveRecord::Migration
  def self.up
    add_column :pages, :tips_and_traps, :text
    add_column :pages, :readings_and_resources, :text
    add_column :pages, :faculty_notes, :text
  end

  def self.down
    remove_column :pages, :faculty_notes
    remove_column :pages, :tips_and_traps
    remove_column :pages, :readings_and_resources
  end
end
