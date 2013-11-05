class AddIndexesForGradingQueue < ActiveRecord::Migration
  def self.up
    add_index :grades, [:course_id, :student_id, :assignment_id]
    add_index :faculty_assignments, :course_id
    add_index :deliverables, [:course_id, :team_id, :assignment_id]
    add_index :deliverables, [:course_id, :creator_id, :assignment_id], :name => 'index_deliverables_on_course_id_and_creator_id_and_assgnmnt_id'
  end

  def self.down
    remove_index :deliverables, :name => 'index_deliverables_on_course_id_and_creator_id_and_assgnmnt_id'
    remove_index :deliverables, [:course_id, :team_id, :assignment_id]
    remove_index :faculty_assignments, :course_id
    remove_index :grades, [:course_id, :student_id, :assignment_id]

  end
end
