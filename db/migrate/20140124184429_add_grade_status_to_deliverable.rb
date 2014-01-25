class AddGradeStatusToDeliverable < ActiveRecord::Migration

  def self.up
    add_column :deliverables, :grade_status, :string, :default => "ungraded"    #graded, drafted, ungraded
  end

  def self.down
    add_column :deliverables, :grade_status, :string
  end
end
