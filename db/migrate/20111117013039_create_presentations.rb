class CreatePresentations < ActiveRecord::Migration
  def self.up
    create_table :presentations do |t|
      t.string   :name
      t.text     :description
      t.integer  :team_id
      t.integer  :course_id
      t.string   :task_number
      t.integer  :creator_id
      t.date     :presentation_date
      t.integer  :user_id
      t.boolean  :feedback_email_sent
      t.timestamps

    end
    add_index :presentations, :presentation_date
    add_index :presentations, :course_id

    create_table :presentation_feedbacks do |t|
      t.integer :evaluator_id
      t.integer :presentation_id
      t.timestamps
    end
    add_index :presentation_feedbacks, [:evaluator_id, :presentation_id], :unique => true,
              :name => 'by_evaluator_and_presentation'

    create_table :presentation_feedback_answers do |t|
      t.integer :feedback_id
      t.integer :question_id
      t.integer :rating
      t.text :comment
      t.timestamps
    end
    add_index :presentation_feedback_answers, [:feedback_id, :question_id], :unique => true,
              :name => 'by_feedback_and_question'

    create_table :presentation_questions do |t|
      t.string :label
      t.text :text
      t.boolean :deleted
      t.timestamps
    end

  end

  def self.down
    drop_table :presentation_questions

    remove_index :presentation_feedback_answers, :name => "by_feedback_and_question"
    drop_table :presentation_feedback_answers

    remove_index :presentation_feedbacks, :name => 'by_evaluator_and_presentation'
    drop_table :presentation_feedbacks

    remove_index :presentations, :course_id
    remove_index :presentations, :presentation_date
    drop_table :presentations
  end
end
