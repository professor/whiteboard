class RenameAuthorsOnPapers < ActiveRecord::Migration
  def self.up
    rename_column :papers, :authors, :authors_full_listing
    remove_column :papers, :authors_more
  end

  def self.down
    add_column :papers, :authors_more, :string
    rename_column :papers, :authors, :authors_full_listing
  end
end
