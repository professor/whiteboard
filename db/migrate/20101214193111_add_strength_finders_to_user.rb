class AddStrengthFindersToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :strength1_id, :integer
    add_column :users, :strength2_id, :integer
    add_column :users, :strength3_id, :integer
    add_column :users, :strength4_id, :integer
    add_column :users, :strength5_id, :integer

    add_column :user_versions, :strength1_id, :integer
    add_column :user_versions, :strength2_id, :integer
    add_column :user_versions, :strength3_id, :integer
    add_column :user_versions, :strength4_id, :integer
    add_column :user_versions, :strength5_id, :integer
  end

  def self.down
    remove_column :users, :strength1_id
    remove_column :users, :strength2_id
    remove_column :users, :strength3_id
    remove_column :users, :strength4_id
    remove_column :users, :strength5_id

    remove_column :user_versions, :strength1_id
    remove_column :user_versions, :strength2_id
    remove_column :user_versions, :strength3_id
    remove_column :user_versions, :strength4_id
    remove_column :user_versions, :strength5_id
  end
end
