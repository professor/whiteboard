class CreatePageAttachments < ActiveRecord::Migration
  def self.up
    create_table :page_attachments do |t|
      t.integer :page_id
      t.string :page_attachment_file_name
      t.string :page_attachment_content_type
      t.integer :page_attachment_file_size
      t.datetime :page_attachment_updated_at
    end
  end

  def self.down
    drop_table :page_attachments
  end
end
