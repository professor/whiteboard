class AddNewUserTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :new_user_token, :string
    add_column :users, :password_reset_token, :string
    add_column :users, :password_reset_sent_at, :datetime
    add_column :user_versions, :new_user_token, :string
    add_column :user_versions, :password_reset_token, :string
    add_column :user_versions, :password_reset_sent_at, :datetime
  end

  def self.down
    remove_column :user_versions, :new_user_token
    remove_column :user_versions, :password_reset_sent_at
    remove_column :user_versions, :password_reset_token
    remove_column :users, :new_user_token
    remove_column :users, :password_reset_sent_at
    remove_column :users, :password_reset_token
  end
end
