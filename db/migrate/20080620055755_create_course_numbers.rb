class CreateCourseNumbers < ActiveRecord::Migration
  def self.up
    create_table :course_numbers do |t|
      t.string :name
      t.string :number
      t.timestamps     
    end   
  end

  def self.down
    drop_table :course_numbers 
  end
end
