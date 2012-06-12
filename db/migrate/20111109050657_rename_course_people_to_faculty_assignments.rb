class RenameCoursePeopleToFacultyAssignments < ActiveRecord::Migration
  def self.up
    remove_index :courses_people, [ :course_id, :person_id ]
    rename_table :courses_people, :faculty_assignments

    create_table "registered_courses" do |t|
      t.integer  "course_id"
      t.integer  "person_id"
      t.timestamps
    end

    add_index :registered_courses, [ :course_id, :person_id ], :unique => true
    add_index :faculty_assignments, [ :course_id, :person_id ], :unique => true
  end

  def self.down
    remove_index :faculty_assignments, [ :course_id, :person_id ]
    remove_index :registered_courses, [ :course_id, :person_id ]

    drop_table :registered_courses

    rename_table :faculty_assignment, :courses_people
    add_index :courses_people, [ :course_id, :person_id ], :unique => true
  end
end
