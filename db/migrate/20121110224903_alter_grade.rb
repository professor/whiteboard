class AlterGrade < ActiveRecord::Migration
  def self.up
    change_column :grades, :score, :text
  end

  def self.down
    change_column :grades, :score, :float
  end
end
