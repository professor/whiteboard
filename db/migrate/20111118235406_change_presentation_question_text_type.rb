class ChangePresentationQuestionTextType < ActiveRecord::Migration
  def self.up
    change_column :presentation_questions, :text, :text
  end

  def self.down
    change_column :presentation_questions, :text, :string
  end
end
