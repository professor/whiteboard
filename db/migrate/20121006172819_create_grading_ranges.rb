class CreateGradingRanges < ActiveRecord::Migration
  def self.up
    create_table :grading_ranges do |t|
      t.string :grade
      t.integer :minimum_value
      t.integer :course_id


      t.timestamps
    end
    add_index :grading_ranges, :course_id
  end

  def self.down
    remove_index :grading_ranges, :course_id
    drop_table :grading_ranges
  end
end
