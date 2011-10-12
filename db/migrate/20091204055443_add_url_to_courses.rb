class AddUrlToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :twiki_url, :string
    add_index :courses, :twiki_url
  end

  def self.down
    remove_index :courses, :twiki_url
    remove_column :courses, :twiki_url
  end
end
