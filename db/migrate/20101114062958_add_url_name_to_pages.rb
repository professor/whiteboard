class AddUrlNameToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :url, :string
    add_index :pages, :url, :unique => true, 
  end

  def self.down
    remove_index :pages, :url
    remove_column :pages, :url
  end
end
