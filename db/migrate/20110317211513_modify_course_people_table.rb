class ModifyCoursePeopleTable < ActiveRecord::Migration
  def self.up

    drop_table :courses_people

    create_table :courses_people, :id => false do |t|
      t.integer :course_id
      t.integer :person_id
      t.timestamps
    end

    add_index :courses_people, [ :course_id, :person_id ], :unique => true
  end

  def self.down

    remove_index :courses_people, [ :course_id, :person_id ]

    drop_table :courses_people

    create_table :courses_people do |t|
      t.integer :course_id
      t.integer :person_id
      t.timestamps
    end    

  end
end
