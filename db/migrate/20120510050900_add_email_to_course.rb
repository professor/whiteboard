class AddEmailToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :email, :string
  end

  def self.down
    remove_column :courses, :email
  end
end
