class AddConfiguredByToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :configured_by_user_id, :integer
  end

  def self.down
    remove_column :courses, :configured_by_user_id
  end
end
