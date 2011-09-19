class AlterUsersFromAuthLogicToDevise < ActiveRecord::Migration
  def self.up

    [:users, :user_versions].each do |table|

      add_column table, :remember_created_at, :timestamp

      remove_column table, :persistence_token
      remove_column table, :crypted_password
      remove_column table, :password_salt
      remove_column table, :single_access_token

      rename_column table, :current_login_at, :current_sign_in_at
      rename_column table, :current_login_ip, :current_sign_in_ip
      rename_column table, :last_login_at, :last_sign_in_at
      rename_column table, :last_login_ip, :last_sign_in_ip

      remove_column table, :last_request_at
      remove_column table, :failed_login_count
      rename_column table, :login_count, :sign_in_count
    end
    remove_column :user_versions, :salt

    add_index :users, :email
  end


  def self.down
    remove_index :users, :email
    add_column :user_versions, :salt, :string, :limit => 40

    [:users, :users_versions].each do |table|
      rename_column table, :sign_in_count, :login_count
      add_column table, :failed_login_count, :integer
      add_column table, :last_request_at, :datetime

      rename_column table, :current_sign_in_at, :current_login_at
      rename_column table, :current_sign_in_ip, :current_login_ip
      rename_column table, :last_sign_in_at, :last_login_at
      rename_column table, :last_sign_in_ip, :last_login_ip

      add_column table, :persistence_token, :string
      add_column table, :crypted_password, :string, :limit => 128
      add_column table, :password_salt, :string
      add_column table, :single_access_token, :string

      remove_column table, :remember_created_at
    end
  end
end
