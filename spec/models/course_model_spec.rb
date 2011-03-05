require 'spec_helper'

describe Course do


  it "should know which courses are offered this semester" do
    list = Course.current_semester_courses
    course = Factory(:fse)
    list2 = Course.current_semester_courses
    list.length.should be_equal list2.length - 1

  end

  it "should know which courses are offered next semester" do
    list = Course.next_semester_courses
    course = Factory(:mfse)
    list2 = Course.next_semester_courses
    list.length.should be_equal list2.length - 1
  end

  it "should know the start of the course (in cweek)" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010", :mini => 'Both')
    course.semester_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :mini => 'A')
    course.semester_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :mini => 'B')
    course.semester_start.should == AcademicCalendar.semester_start("Fall", 2010) + 7

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'Both')
    course.semester_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'A')
    course.semester_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'B')
    course.semester_start.should == AcademicCalendar.semester_start("Spring", 2010) + 7

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'Both')
    course.semester_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'A')
    course.semester_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'B')
    course.semester_start.should == AcademicCalendar.semester_start("Summer", 2010) + 6

  end
  
end