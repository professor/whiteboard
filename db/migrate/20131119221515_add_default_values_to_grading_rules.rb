class AddDefaultValuesToGradingRules < ActiveRecord::Migration
  def self.up
    change_column :grading_rules, :A_grade_min, :float, :default => 94.0
    change_column :grading_rules, :A_minus_grade_min, :float, :default => 90.0
    change_column :grading_rules, :B_plus_grade_min, :float, :default => 87.0
    change_column :grading_rules, :B_grade_min, :float, :default => 83.0
    change_column :grading_rules, :B_minus_grade_min, :float, :default => 80.0
    change_column :grading_rules, :C_plus_grade_min, :float, :default => 78.0
    change_column :grading_rules, :C_grade_min, :float, :default => 74.0
    change_column :grading_rules, :C_minus_grade_min, :float, :default => 70.0
  end

  def self.down
    change_column :grading_rules, :A_grade_min, :float, :default => nil
    change_column :grading_rules, :A_minus_grade_min, :float, :default => nil
    change_column :grading_rules, :B_plus_grade_min, :float, :default => nil
    change_column :grading_rules, :B_grade_min, :float, :default => nil
    change_column :grading_rules, :B_minus_grade_min, :float, :default => nil
    change_column :grading_rules, :C_plus_grade_min, :float, :default => nil
    change_column :grading_rules, :C_grade_min, :float, :default => nil
    change_column :grading_rules, :C_minus_grade_min, :float, :default => nil
  end
end
