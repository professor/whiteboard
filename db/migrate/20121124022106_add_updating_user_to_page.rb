class AddUpdatingUserToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :current_edit_by_user_id, :integer
    add_column :pages, :current_edit_started_at, :datetime
  end

  def self.down
    remove_column :pages, :current_edit_started_at
    remove_column :pages, :current_edit_by_user_id
  end
end
