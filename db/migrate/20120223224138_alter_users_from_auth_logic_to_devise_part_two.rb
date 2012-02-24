class AlterUsersFromAuthLogicToDevisePartTwo < ActiveRecord::Migration
 def self.up
   #When we switched to devise, we didn't get all the columns that we needed for rememberable
   remove_column :users, :remember_created_at
   remove_column :user_versions, :remember_created_at

    change_table(:users) do |t|
      t.rememberable
    end
    change_table(:user_versions) do |t|
      t.rememberable
    end
 end
 
  def self.down
    remove_column :users, :rememberable
    remove_column :user_versions, :rememberable

    add_column :users, :remember_created_at, :timestamp
    add_column :user_versions, :remember_created_at, :timestamp
  end
end

