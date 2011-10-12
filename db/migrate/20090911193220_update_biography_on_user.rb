class UpdateBiographyOnUser < ActiveRecord::Migration
  def self.up
    change_column :users, :biography, :text
    change_column :users, :user_text, :text
  end

  def self.down
    change_column :users, :user_text, :string
    change_column :users, :biography, :string
  end
end
