class AddNameToPageAttachment < ActiveRecord::Migration
  def self.up
    add_column :page_attachments, :name, :string
  end

  def self.down
    remove_column :page_attachments, :name
  end
end
