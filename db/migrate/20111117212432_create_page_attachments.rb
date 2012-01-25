class CreatePageAttachments < ActiveRecord::Migration
  def self.up
    create_table :page_attachments do |t|
      t.integer :page_id
      t.integer :user_id
      t.integer :position
      t.boolean :is_active,  :default => true
      t.string :readable_name
      t.string :page_attachment_file_name
      t.string :page_attachment_content_type
      t.integer :page_attachment_file_size
      t.datetime :page_attachment_updated_at
    end

    add_index :page_attachments, :page_id
    add_index :page_attachments, :position
    add_index :page_attachments, :is_active
  end

  def self.down
    drop_table :page_attachments
  end
end
