class AddGradeStatusToDeliverable < ActiveRecord::Migration

  def self.up
    add_column :deliverables, :grade_status, :string, :default => "ungraded"    #graded, drafted, ungraded
  end

  # To fix existing data
  #Deliverable.all.each { |d| d.update_attributes(:grade_status => d.get_grade_status.to_s)  }

  def self.down
    add_column :deliverables, :grade_status, :string
  end
end
