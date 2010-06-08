class CreateCurriculumCommentTypes < ActiveRecord::Migration
  def self.up
    create_table :curriculum_comment_types do |t|
      t.string :name
      t.string :background_color

      t.timestamps
    end
    rename_column :curriculum_comments, :type, :curriculum_comment_type_id

  end

  def self.down
    rename_column :curriculum_comments, :curriculum_comment_type_id, :type
    drop_table :curriculum_comment_types
  end
end
