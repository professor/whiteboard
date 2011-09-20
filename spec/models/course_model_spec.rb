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

  context "custom finders" do

    specify { Course.should respond_to(:last_offering) }

    it 'finds the last course offered with the same course number' do
      @first = Factory(:course, :semester => "Fall", :year => 2010)
      @third = Factory(:course, :semester => "Summer", :year => 2011)
      @second = Factory(:course, :semester => "Spring", :year => 2011)
      Course.last_offering(@first.number).should == @third
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
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FoundationsofSoftwareEngineering/WebHome"

    course = Factory.build(:course, :semester => "Fall", :year => "2010", :short_name => "FSE")
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FSE/WebHome"
  end

  it "should auto_generated_peer_evaluation_date_start" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_start.to_s.should == "2010-10-04"
  end

  it "should auto_generated_peer_evaluation_date_end" do
    course = Factory.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_end.to_s.should == "2010-10-11"
  end

  it "is versioned" do
    course = Factory.build(:course)
    course.should respond_to(:version)
    course.save
    version_number = course.version
    course.name = "I changed my mind"
    course.save
    course.version.should == version_number + 1
  end

  context "copied as new course" do
    it "responds to " do
      subject.should respond_to(:copy_as_new_course)
    end

    it "all attributes are copied except 'is_configured'" do
      course = Factory(:course)
      new_course = course.copy_as_new_course
      new_course.save
      course.attributes.each do |key, value|
        case key
          when "is_configured"
            new_course.is_configured.should == false
          when "id"
            new_course.id.should_not == course.id
          when "curriculum_url"
            if value.nil? || value.include?("twiki")
              new_course.curriculum_url.should be_nil
            else
              new_course.curriculum_url.should == value
            end
          else
            new_course.attributes[key].should == value
        end
      end
    end

    it "also copies over the people association" do
# Todo: fix this when user and person are the same class
#      course = Factory(:course, :people => [@faculty_frank])
      course = Factory(:course)
      new_course = course.copy_as_new_course
      new_course.save
      new_course.faculty.should =~ course.faculty
    end

  end


end