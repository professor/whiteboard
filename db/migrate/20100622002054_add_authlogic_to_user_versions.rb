class AddAuthlogicToUserVersions < ActiveRecord::Migration
  def self.up

    change_table :user_versions do |t|

    t.string    :password_salt,       :null => false, :default => 0 # optional, but highly recommended
    t.string    :persistence_token,   :null => false, :default => 0 # required
    t.string    :single_access_token, :null => false, :default => 0 # optional, see Authlogic::Session::Params
    t.string    :perishable_token,    :null => false, :default => 0 # optional, see Authlogic::Session::Perishability

    # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
    t.integer   :login_count,         :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
    t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
    t.datetime  :last_request_at                                    # optional, see Authlogic::Session::MagicColumns
    t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
    t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
    t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
    t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
    end

#    remove_column :user_versions, :salt
    remove_column :user_versions, :remember_token
    remove_column :user_versions, :remember_token_expires_at

  end

  def self.down

 #   add_column :user_versions, :salt, :string
    add_column :user_versions, :remember_token, :string
    add_column :user_versions, :remember_token_expires_at, :string

    remove_column  :user_versions, :password_salt
    remove_column  :user_versions, :persistence_token
    remove_column  :user_versions, :single_access_token
    remove_column  :user_versions, :perishable_token

    remove_column  :user_versions, :login_count
    remove_column  :user_versions, :failed_login_count
    remove_column  :user_versions, :last_request_at
    remove_column  :user_versions, :current_login_at
    remove_column  :user_versions, :last_login_at
    remove_column  :user_versions, :current_login_ip
    remove_column  :user_versions, :last_login_ip
  end
end
