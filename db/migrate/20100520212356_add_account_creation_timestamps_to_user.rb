class AddAccountCreationTimestampsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :google_created, :timestamp
    add_column :users, :twiki_created, :timestamp
    add_column :users, :adobe_created, :timestamp
    add_column :users, :msdnaa_created, :timestamp

    add_column :user_verions, :google_created, :timestamp
    add_column :user_verions, :twiki_created, :timestamp
    add_column :user_verions, :adobe_created, :timestamp
    add_column :user_verions, :msdnaa_created, :timestamp
  end

  def self.down
    remove_column :users, :google_created
    remove_column :users, :twiki_created
    remove_column :users, :adobe_created
    remove_column :users, :msdnaa_created

    remove_column :user_verions, :google_created
    remove_column :user_verions, :twiki_created
    remove_column :user_verions, :adobe_created
    remove_column :user_verions, :msdnaa_created
  end
end
