class AddFall2008Courses < ActiveRecord::Migration
  def self.up
    @course1 = Course.create :course_number_id => 1, :name => "Foundations of Software Engineering", :number => "96-700", :semester => "Fall", :mini => "Both", :year => "2008" 
    @course2 = Course.create :course_number_id => 4, :name => "Metrics for Software Engineers", :number => "96-703", :semester => "Fall", :mini => "B", :year => "2008" 
    @course3 = Course.create :course_number_id => 13, :name => "Elements of Software Management", :number => "96-780", :semester => "Fall", :mini => "A", :year => "2008" 
    @course4 = Course.create :course_number_id => 1, :name => "Metrics for Software Managers", :number => "96-781", :semester => "Fall", :mini => "B", :year => "2008" 
    @course5 = Course.create :course_number_id => 1, :name => "Avoiding Software Project Failures", :number => "96-709", :semester => "Fall", :mini => "A", :year => "2008" 
    @course6 = Course.create :course_number_id => 1, :name => "Software Product Definition", :number => "96-788", :semester => "Fall", :mini => "A", :year => "2008" 
    @course7 = Course.create :course_number_id => 1, :name => "Software Product Strategy", :number => "96-790", :semester => "Fall", :mini => "B", :year => "2008" 
    @course8 = Course.create :course_number_id => 1, :name => "Introduction to Software Engineering", :number => "96-821", :semester => "Fall", :mini => "B", :year => "2008" 
    
    
  end

  def self.down
  end
end
