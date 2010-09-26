class RenamePageAttributes < ActiveRecord::Migration
  def self.up
    rename_column :pages, :label, :title
    add_column :pages, :updated_by_user_id, :integer
    add_column :pages, :version, :integer
    add_column :pages, :version_comments, :string
 end

  def self.down
    rename_column :pages, :title, :label
    remove_column :pages, :updated_by_user_id
    remove_column :pages, :version
    remove_column :pages, :version_comments
  end
  
end
