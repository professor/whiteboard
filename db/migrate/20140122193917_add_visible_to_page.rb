class AddVisibleToPage < ActiveRecord::Migration

  def self.up
    add_column :pages, :visible, :boolean, :default => true
  end

  def self.down
    remove_column :pages, :visible
  end
end
