class AddFeedbackToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :feedback_comment, :string
    add_column :deliverables, :feedback_file_name, :string
    add_column :deliverables, :feedback_content_type, :string
    add_column :deliverables, :feedback_file_size, :integer
  end

  def self.down
    remove_column :deliverables, :feedback_comment
    remove_column :deliverables, :feedback_file_name
    remove_column :deliverables, :feedback_content_type
    remove_column :deliverables, :feedback_file_size
  end
end
