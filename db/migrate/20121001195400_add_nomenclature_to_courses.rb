class AddNomenclatureToCourses < ActiveRecord::Migration
  def self.up
    add_column :courses, :grading_nomenclature, :string
    add_column :courses, :grading_criteria, :string
    add_column :courses, :grading_range, :string
  end

  def self.down
    remove_column :courses, :grading_range
    remove_column :courses, :grading_criteria
    remove_column :courses, :grading_nomenclature
  end
end