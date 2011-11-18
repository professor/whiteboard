class AddNameToPresentations < ActiveRecord::Migration
  def self.up
    add_column :presentations, :name, :string
  end

  def self.down
    remove_column :presentations, :name
  end
end
