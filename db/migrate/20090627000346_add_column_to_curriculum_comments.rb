class AddColumnToCurriculumComments < ActiveRecord::Migration
  def self.up
    add_column :curriculum_comments, :human_name, :string
  end

  def self.down
    remove_column :curriculum_comments, :human_name
  end
end
