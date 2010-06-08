class AddSummer2009Courses < ActiveRecord::Migration
  def self.up
    
    @semester = "Summer"
    @year = "2009"
    

    @course_number_architecture = CourseNumber.find_by_name "Architecture and Design I"
    @course_number_mod          = CourseNumber.find_by_name "Managing Outsourced Development Elective I"
    @course_number_se_practicum = CourseNumber.find_by_name "Software Engineering Practicum I"
    @course_number_sm_practicum = CourseNumber.find_by_name "Practicum I"
    @course_number_iande        = CourseNumber.find_by_name "Innovation and Entrepreneurship"
    @course_number_iande_sm     = CourseNumber.create :name => "Innovation and Entrepreneurship for Software Management", :number => "96-815"    
    @course_number_hci = CourseNumber.find_by_name "Human-Computer Interaction"
    @course_number_aspf = CourseNumber.find_by_name "Avoiding Project Failures"
    @course_number_oss = CourseNumber.find_by_name "Introduction to Open Source" 
    @course_number_oss_tech = CourseNumber.create :name => "Introduction to Open Source Technical", :number => "96-787"    
    
    @course1 = Course.create :course_number_id => @course_number_architecture.id, :name => "Architecture and Design", :number => "96-705", :semester => @semester, :mini => "Both", :year => @year
    @course2 = Course.create :course_number_id => @course_number_mod.id, :name => "Managing Outsourced Development", :number => "96-784", :semester => @semester, :mini => "Both", :year => @year
    @course3 = Course.create :course_number_id => @course_number_se_practicum.id, :name => "SE Practicum", :number => "96-710", :semester => @semester, :mini => "Both", :year => @year
    @course4 = Course.create :course_number_id => @course_number_sm_practicum.id, :name => "SM Practicum", :number => "96-794", :semester => @semester, :mini => "Both", :year => @year
    @course5 = Course.create :course_number_id => @course_number_iande.id, :name => "Innovation and Entrepreneurship", :number => "96-818", :semester => @semester, :mini => "Both", :year => @year
    @course6 = Course.create :course_number_id => @course_number_iande_sm.id, :name => "Innovation and Entrepreneurship (SM)", :number => "96-815", :semester => @semester, :mini => "Both", :year => @year
    @course7 = Course.create :course_number_id => @course_number_hci.id, :name => "Human Computer Interaction", :number => "96-796", :semester => @semester, :mini => "Both", :year => @year
    @course8 = Course.create :course_number_id => @course_number_aspf.id, :name => "Avoiding Software Project Failures", :number => "96-709", :semester => @semester, :mini => "Both", :year => @year
    @course9 = Course.create :course_number_id => @course_number_oss.id, :name => "Open Source Software (Business)", :number => "96-786", :semester => @semester, :mini => "Both", :year => @year
    @course10 = Course.create :course_number_id => @course_number_oss_tech.id, :name => "Open Source Software (Technical)", :number => "96-787", :semester => @semester, :mini => "Both", :year => @year
    

  end

  def self.down
  end
end
