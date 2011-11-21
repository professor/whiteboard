class CreatePresentationFeedbackAnswers < ActiveRecord::Migration
  def self.up
    create_table :presentation_feedback_answers do |t|
      t.integer :feedback_id
      t.integer :question_id
      t.integer :rating
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :presentation_feedback_answers
  end
end
