class AddIndexToUserIsActive < ActiveRecord::Migration
  def self.up
    add_index(:users, :is_active)
  end

  def self.down
    remove_index :users, :is_active
  end
end
