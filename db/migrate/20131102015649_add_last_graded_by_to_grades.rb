class AddLastGradedByToGrades < ActiveRecord::Migration
  def self.up
    add_column :grades, :last_graded_by, :integer
  end

  def self.down
    remove_column :grades, :last_graded_by
  end
end
