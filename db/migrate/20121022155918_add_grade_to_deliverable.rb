class AddGradeToDeliverable < ActiveRecord::Migration
  def self.up
    add_column :deliverables, :grade, :integer
  end

  def self.down
    remove_column :deliverables, :grade
  end
end
