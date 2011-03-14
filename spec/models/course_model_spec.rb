require 'spec_helper'

describe Course do


  it 'can be created' do
    lambda {
      Factory(:course)
    }.should change(Course, :count).by(1)
  end

  context "is not valid" do

    [:semester, :year, :mini, :name].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end
  end


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
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010) + 7

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'Both')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = Factory.build(:course, :semester => "Spring", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010) + 7

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'Both')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = Factory.build(:course, :semester => "Summer", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010) + 6

  end

  it "should be able to auto_generated_twiki_url" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010", :name => "Foundations of Software Engineering")
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FoundationsofSoftwareEngineering"

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :short_name => "FSE")
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FSE"
  end

  it "should auto_generated_peer_evaluation_date_start" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_start.to_s.should == "2010-10-08"
  end

  it "should auto_generated_peer_evaluation_date_end" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_end.to_s.should == "2010-10-15"
  end


end