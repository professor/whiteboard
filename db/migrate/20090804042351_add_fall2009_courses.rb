class AddFall2009Courses < ActiveRecord::Migration
  def self.up
    @semester = "Fall"
    @year = "2009"

    @course_number_foundations  = CourseNumber.find_by_name "Foundations of Software Engineering I"
    @course_number_intro_se     = CourseNumber.find_by_name "Introduction to Software Engineering"
    @course_number_aspf         = CourseNumber.find_by_name "Avoiding Project Failures"
    @course_number_mfse         = CourseNumber.find_by_name "Metrics for Software Engineers"
    @course_number_mfsm         = CourseNumber.find_by_name "Metrics for Software Managers"
    @course_number_esm          = CourseNumber.find_by_name "Elements of Software Management"
    @course_number_spd          = CourseNumber.find_by_name "Product Definition"
    @course_number_ra           = CourseNumber.find_by_name "Requirements Analysis"
    @course_number_dr           = CourseNumber.create :name => "Directed Research", :number => "96-826"
    @course_number_pc           = CourseNumber.create :name => "Pervasive Systems", :number => "18-843"
    @course_number_sdl          = CourseNumber.create :name => "Statistical Discovery and Learning", :number => "18-799"

    @course1 = Course.create :course_number_id => @course_number_foundations.id, :name => "Foundations of Software Engineering", :number => "96-700", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Primary faculty"
    @course2 = Course.create :course_number_id => @course_number_aspf.id, :name => "Avoiding Software Project Failures", :number => "96-709", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Primary faculty"
    @course3 = Course.create :course_number_id => @course_number_intro_se.id, :name => "Introduction to Software Engineering", :number => "96-821", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Primary faculty"
    @course4 = Course.create :course_number_id => @course_number_mfse.id, :name => "Metrics for Software Engineers", :number => "96-703", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Primary faculty"
    @course5 = Course.create :course_number_id => @course_number_mfsm.id, :name => "Metrics for Software Managers", :number => "96-781", :semester => @semester, :mini => "B", :year => @year, :primary_faculty_label => "Supervising faculty", :secondary_faculty_label => "Coach"
    @course6 = Course.create :course_number_id => @course_number_esm.id, :name => "Elements of Software Management", :number => "96-780", :semester => @semester, :mini => "A", :year => @year, :primary_faculty_label => "Supervising faculty", :secondary_faculty_label => "Coach"
    @course7 = Course.create :course_number_id => @course_number_spd.id, :name => "Software Product Definition", :number => "96-788", :semester => @semester, :mini => "A", :year => @year, :primary_faculty_label => "Supervising faculty", :secondary_faculty_label => "Coach"
    @course8 = Course.create :course_number_id => @course_number_ra.id, :name => "Requirements Analysis", :number => "96-789", :semester => @semester, :mini => "B", :year => @year, :primary_faculty_label => "Supervising faculty", :secondary_faculty_label => "Coach"
    @course9 = Course.create :course_number_id => @course_number_dr.id, :name => "Directed Research", :number => "96-826", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Primary faculty"
    @course10 = Course.create :course_number_id => @course_number_pc.id, :name => "Pervasive Systems ", :number => "18-843", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Instructor"
    @course11 = Course.create :course_number_id => @course_number_sdl.id, :name => "Statistical Discovery and Learning", :number => "18-799", :semester => @semester, :mini => "Both", :year => @year, :primary_faculty_label => "Instructor"
  end

  def self.down
  end
end
