class AddIndexToCurriculumComments < ActiveRecord::Migration
  def self.up
    add_index :curriculum_comments, :url
    add_index :curriculum_comments, :semester
    add_index :curriculum_comments, :year

  end

  def self.down
    remove_index :curriculum_comments, :url
    remove_index :curriculum_comments, :semester
    remove_index :curriculum_comments, :year
  end
end
