class ModifyUserColumnsForCurrentNomenclature < ActiveRecord::Migration
  def self.up
    rename_column :users, :masters_program, :educational_program
    rename_column :users, :masters_track, :educational_track
    rename_column :users, :organization_name, :company_name
    rename_column :users, :webiso_account, :andrew_account

    rename_column :user_versions, :masters_program, :educational_program
    rename_column :user_versions, :masters_track, :educational_track
    rename_column :user_versions, :organization_name, :company_name
    rename_column :user_versions, :webiso_account, :andrew_account

    remove_column :users, :yammer_created
    remove_column :user_versions, :yammer_created
  end

  def self.down
    add_column :users, :yammer_created, :timestamp
    add_column :user_versions, :yammer_created, :timestamp

    rename_column :users, :educational_program, :masters_program
    rename_column :users, :educational_track, :masters_track
    rename_column :users, :company_name, :organization_name
    rename_column :users, :andrew_account, :webiso_account
    rename_column :user_versions, :educational_program, :masters_program
    rename_column :user_versions, :educational_track, :masters_track
    rename_column :user_versions, :company_name, :organization_name
    rename_column :user_versions, :andrew_account, :webiso_account
  end
end
