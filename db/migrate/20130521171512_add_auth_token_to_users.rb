class AddAuthTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :auth_token, :string
  end

  def self.down
    remove_column :users, :auth_token
  end
end
