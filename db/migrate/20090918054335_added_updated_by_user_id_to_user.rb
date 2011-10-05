class AddedUpdatedByUserIdToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :updated_by_user_id, :integer
  end

  def self.down
    remove_column :users, :updated_by_user_id
  end
end
