class CreateCurriculumComments < ActiveRecord::Migration
  def self.up
    create_table :curriculum_comments do |t|
      t.string :url
      t.string :semester
      t.string :year
      t.integer :user_id
      t.integer :type
      t.string :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :curriculum_comments
  end
end
