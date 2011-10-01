class AddVersioningToUser < ActiveRecord::Migration
  def self.up
    Person.create_versioned_table # :table_name => 'user_verions'
  end

  def self.down
    Person.drop_versioned_table
  end
end
