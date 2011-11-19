class CreatePresentationFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :presentation_feedbacks do |t|
      t.integer :user_id
      t.integer :presentation_id
      t.integer :content
      t.text :content_comment
      t.integer :organization
      t.text :organization_comment
      t.integer :visual
      t.text :visual_comment
      t.integer :delivery
      t.text :delivery_comment
      t.text :general_comment

      t.timestamps
    end
  end

  def self.down
    drop_table :presentation_feedbacks
  end
end
