class AddUpdatingUserToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :updater_user_id, :integer
    add_column :pages, :updating_started_at, :datetime
  end

  def self.down
    remove_column :pages, :updating_started_at
    remove_column :pages, :updater_user_id
  end
end
