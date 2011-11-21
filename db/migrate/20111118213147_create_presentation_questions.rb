class CreatePresentationQuestions < ActiveRecord::Migration
  def self.up
    create_table :presentation_questions do |t|
      t.string :text
      t.boolean :is_deleted

      t.timestamps
    end
  end

  def self.down
    drop_table :presentation_questions
  end
end
