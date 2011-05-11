class AlterDeliverableRevisionsTable < ActiveRecord::Migration
  def self.up
    rename_table(:deliverable_revisions, :deliverable_attachment_versions)

    rename_column(:deliverable_attachment_versions, :revision_file_name, :attachment_file_name)
    rename_column(:deliverable_attachment_versions, :revision_file_size, :attachment_file_size)
    rename_column(:deliverable_attachment_versions, :revision_content_type, :attachment_content_type)

    rename_column(:deliverables, :description, :name)

  end

  def self.down
    rename_column(:deliverables, :name, :description)

    rename_column(:deliverable_attachment_versions, :attachment_content_type, :revision_content_type)
    rename_column(:deliverable_attachment_versions, :attachment_file_size, :revision_file_size)
    rename_column(:deliverable_attachment_versions,  :attachment_file_name, :revision_file_name)

    rename_table(:deliverable_attachment_versions, :deliverable_revisions)
  end
end
