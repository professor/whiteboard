class UpdateUrlNameToPages < ActiveRecord::Migration
  def self.up
    remove_index :pages, :url
    add_index :pages, :url
  end

  def self.down
# the add_index line won't work if there is data in the database where the url field is blank for more than one entry
#    remove_index :pages, :url
#    add_index :pages, :url  :unique => true
  end
end
