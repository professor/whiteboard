class ModifyDeliverableCommentsLength < ActiveRecord::Migration
  def self.up
    change_column :deliverables, :feedback_comment, :text
  end

  def self.down
    change_column :deliverables, :feedback_comment, :string
  end
end
