class CreateGradingRules < ActiveRecord::Migration
  def self.up
    create_table :grading_rules do |t|
      t.string :grade_type
      t.float :A_grade_min
      t.float :A_minus_grade_min
      t.float :B_plus_grade_min
      t.float :B_grade_min
      t.float :B_minus_grade_min
      t.float :C_plus_grade_min
      t.float :C_grade_min
      t.float :C_minus_grade_min
      t.integer :course_id

      t.timestamps
    end
  end

  def self.down
    drop_table :grading_rules
  end
end
