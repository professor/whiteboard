class CreatePageAttachments < ActiveRecord::Migration
  def self.up
    create_table :page_attachments do |t|
      t.integer  "page_id"
      t.integer  "submitter_id"
      t.datetime "submission_date"
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.text     "comment"
      t.timestamps
    end
  end

  def self.down
    drop_table :page_attachments
  end
end
