class AddGradingCriteriaToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :is_assignment_points, :boolean
    add_column :courses, :A_plus_grade, :float
    add_column :courses, :A_grade, :float
    add_column :courses, :A_minus_grade, :float
    add_column :courses, :B_plus_grade, :float
    add_column :courses, :B_grade, :float
    add_column :courses, :B_minus_grade, :float
    add_column :courses, :C_plus_grade, :float
    add_column :courses, :C_grade, :float
    add_column :courses, :C_minus_grade, :float
  end

  def self.down
    remove_column :courses, :is_assignment_points
    remove_column :courses, :A_plus_grade
    remove_column :courses, :A_grade
    remove_column :courses, :A_minus_grade
    remove_column :courses, :B_plus_grade
    remove_column :courses, :B_grade
    remove_column :courses, :B_minus_grade
    remove_column :courses, :C_plus_grade
    remove_column :courses, :C_grade
    remove_column :courses, :C_minus_grade
  end
end
