class AddSpring2009BCourses < ActiveRecord::Migration
  def self.up
    
    @semester = "Spring"
    @year = "2009"
    
    @course_number_organizational_behavior = CourseNumber.create :name => "Organizational Behavior", :number => "96-808"
    
    @course1 = Course.create :course_number_id => @course_number_organizational_behavior.id, :name => "Organizational Behavior", :number => "96-808", :semester => @semester, :mini => "B", :year => @year

  end

  def self.down
  end
end
