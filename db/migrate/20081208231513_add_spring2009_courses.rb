class AddSpring2009Courses < ActiveRecord::Migration
  def self.up
    
    @semester = "Spring"
    @year = "2009"
    
    @courese_number_mobile_ecosystem = CourseNumber.create :name => "The Mobile Ecosystem", :number => "96-822"
    @courese_number_mobile_hardware = CourseNumber.create :name => "Mobile Hardware for Software Engineers", :number => "96-825"
    @courese_number_mobile_ue = CourseNumber.create :name => "Designing the Mobile User Experience", :number => "96-823"
    @courese_number_improv = CourseNumber.create :name => "Improvisation for Engineers", :number => "96-827"
    @courese_number_ini_practicums = CourseNumber.create :name => "INI Practicum", :number => "14-798"
    
    @course1 = Course.create :course_number_id => 11, :name => "Software Engineering Practicum", :number => "96-710", :semester => @semester, :mini => "Both", :year => @year
    @course2 = Course.create :course_number_id => 15, :name => "Project and Process Management", :number => "96-782", :semester => @semester, :mini => "A", :year => @year
    @course3 = Course.create :course_number_id => 16, :name => "Managing Software Professionals", :number => "96-783", :semester => @semester, :mini => "B", :year => @year
    @course4 = Course.create :course_number_id => 21, :name => "Requirements Analysis", :number => "96-789", :semester => @semester, :mini => "A", :year => @year
    @course5 = Course.create :course_number_id => 23, :name => "The Business of Software", :number => "96-791", :semester => @semester, :mini => "B", :year => @year
    @course6 = Course.create :course_number_id => 3, :name => "Requirements Engineering", :number => "96-702", :semester => @semester, :mini => "Both", :year => @year
    @course7 = Course.create :course_number_id => @courese_number_mobile_ecosystem.id, :name => "The Mobile Ecosystem", :number => "96-822", :semester => @semester, :mini => "A", :year => @year
    @course8 = Course.create :course_number_id => @courese_number_mobile_hardware.id, :name => "Mobile Hardware for Software Engineers", :number => "96-825", :semester => @semester, :mini => "B", :year => @year
    @course9 = Course.create :course_number_id => @courese_number_mobile_ue.id, :name => "Designing the Mobile User Experience", :number => "96-823", :semester => @semester, :mini => "B", :year => @year
    @course10 = Course.create :course_number_id => @courese_number_improv.id, :name => "Improvisation for Engineers", :number => "96-827", :semester => @semester, :mini => "Both", :year => @year
    @course11 = Course.create :course_number_id => @courese_number_ini_practicums.id, :name => "INI Practicum", :number => "14-798", :semester => @semester, :mini => "Both", :year => @year

  end

  def self.down
  end
end
