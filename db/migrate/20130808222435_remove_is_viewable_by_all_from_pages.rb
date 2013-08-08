class RemoveIsViewableByAllFromPages < ActiveRecord::Migration
  def self.up
    remove_column :pages, :is_viewable_by_all
  end

  def self.down
    add_column :pages, :is_viewable_by_all, :boolean
  end
end
