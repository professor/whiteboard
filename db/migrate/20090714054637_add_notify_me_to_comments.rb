class AddNotifyMeToComments < ActiveRecord::Migration
  def self.up
    add_column :curriculum_comments, :notify_me, :boolean
  end

  def self.down
    remove_column :curriculum_comments, :notify_me
  end
end
