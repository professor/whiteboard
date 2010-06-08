class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.references :course_number #course_template
      t.string :name
      t.string :number
      t.string :semester
      t.string :mini
      t.string :year
      t.timestamps
    end
    
    add_index :courses, :semester
    add_index :courses, :year
  end

  def self.down
    drop_table :courses
  end
end
