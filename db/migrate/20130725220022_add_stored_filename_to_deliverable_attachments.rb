class AddStoredFilenameToDeliverableAttachments < ActiveRecord::Migration
  def self.up
    add_column :deliverable_attachment_versions, :stored_filename, :text
  end

  def self.down
    remove_column :deliverable_attachment_versions, :stored_filename
  end
end


# Run this on console
# DeliverableAttachment.all.each { |da| da.update_attributes(:stored_filename => da.attachment) }