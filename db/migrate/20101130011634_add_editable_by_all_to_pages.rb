class AddEditableByAllToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :is_editable_by_all, :boolean, :default => false
  end

  def self.down
    remove_column :pages, :is_editable_by_all
  end
end
