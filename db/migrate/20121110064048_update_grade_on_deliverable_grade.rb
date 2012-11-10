class UpdateGradeOnDeliverableGrade < ActiveRecord::Migration
  def self.up
    change_column :deliverable_grades, :grade, :string
  end

  def self.down
    change_column :deliverable_grades, :grade, :integer
  end
end
