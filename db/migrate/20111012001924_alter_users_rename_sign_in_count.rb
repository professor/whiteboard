class AlterUsersRenameSignInCount < ActiveRecord::Migration
    def self.up
      [:users, :user_versions].each do |table|
        rename_column table, :sign_in_count, :sign_in_count_old
        add_column table, :sign_in_count, :integer, :default => 0
      end
    end

    def self.down
      [:users, :user_versions].each do |table|
        remove_column table, :sign_in_count
        rename_column table, :sign_in_count_old, :sign_in_count
#        add_column table, :sign_in_count, :integer, :default => 0,  :null => false
      end
    end
end
