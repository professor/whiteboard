class AddPromisedGaFieldToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :is_ga_promised, :boolean
    add_column :user_versions, :is_ga_promised, :boolean
  end

  def self.down
    remove_column :users, :is_ga_promised, :boolean
    remove_column :user_versions, :is_ga_promised, :boolean
  end
end
