class RenameGradeBooksToGrades < ActiveRecord::Migration
  def self.up
    rename_table :grade_books, :grades
  end

  def self.down
    rename_table :grades, :grade_books
  end
end
