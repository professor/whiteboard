class AddFeedbackToPresentation < ActiveRecord::Migration
  def self.up
    add_column :presentations, :feedback_provided, :boolean
  end

  def self.down
    remove_column :presentations, :feedback_provided
  end
end
