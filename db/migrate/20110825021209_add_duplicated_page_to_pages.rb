class AddDuplicatedPageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :is_duplicated_page, :boolean, :default => false
    Page.update_all ["is_duplicated_page = ?", false]
  end

  def self.down
    remove_column :pages, :is_duplicate_page
  end
end
