class CreatePresentationFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :presentation_feedbacks do |t|
      t.integer :evaluator_id
      t.integer :presentation_id

      t.timestamps
    end
  end

  def self.down
    drop_table :presentation_feedbacks
  end
end
