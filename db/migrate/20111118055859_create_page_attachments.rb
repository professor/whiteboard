class CreatePageAttachments < ActiveRecord::Migration
  def self.up
    create_table :page_attachments do |t|
      t.integer :page_id
      t.integer :owner_id
      t.string :attachment_file_name
      t.integer :attachment_file_size
      t.string :attachment_content_type

      t.timestamps
    end
  end

  def self.down
    drop_table :page_attachments
  end
end
