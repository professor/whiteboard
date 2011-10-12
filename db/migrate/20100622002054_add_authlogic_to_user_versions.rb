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

# Do these after the move
#    remove_column :users, :salt
#    remove_column :users, :remember_token
#    remove_column :users, :remember_token_expires_at

  end

  def self.down

#    add_column :users, :salt, :string
#    add_column :users, :remember_token, :string
#    add_column :users, :remember_token_expires_at, :string

    remove_column  :users,   :password_salt
    remove_column  :users,   :persistence_token
    remove_column  :users,   :single_access_token
    remove_column  :users,   :perishable_token

    remove_column  :users,  :login_count
    remove_column  :users,  :failed_login_count
    remove_column  :users, :last_request_at
    remove_column  :users, :current_login_at
    remove_column  :users, :last_login_at
    remove_column  :users, :current_login_ip
    remove_column  :users, :last_login_ip
  end
end
