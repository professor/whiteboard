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


  #it "display name should return the name" do
  #    @course = Factory(:mfse)
  #  result = @course.display_course_name
  #  result.should ==  "MfSESpring2012"
  #end

   #context "Display name" do
   #  it "should display a no short name right" do
   #    course = Factory(:course)
   #    course.display_name.should == "Course"
   #  end
   #  it "should display with a short name correctly" do
   #    course = Factory(:fse)
   #    course.display_name.should == "Foundations of Software Engineering (FSE)"
   #  end
   # it "should show the short name if there is one" do
   #   course = Factory(:fse)
   #   course.short_or_full_name.should == "FSE"
   # end
   #  it "shouldn't show short name if there isn't" do
   #    course = Factory(:course)
   #    course.short_or_full_name.should == "Course"
   #    course = Factory(:fse,:short_name => "")
   #    course.short_or_full_name.should == "Foundations of Software Engineering"
   #  end
   #end
  #
  #
  # context "display semester" do
  #   it "should display semester right" do
  #     course = Factory(:mfse)
  #     course.display_semester.should == "Spring2012"
  #   end
  # end
  #  context "remind about effort" do
  #    it "should remind for mini= both or something" do
  #      course = Factory(:fse, :remind_about_effort => true)
  #      Course.remind_about_effort_course_list[0].should == course
  #    end
  #    it "should remind for mini is not both" do
  #      course2 = Factory(:mfse_current_semester,:remind_about_effort => true, :mini => "A")
  #      Course.remind_about_effort_course_list[0].should == course2
  #    end
  #end

  #it "first_offering_for_course_name should return the first course given one" do
  #    @course = Factory(:mfse)
  #    @first = Course.first_offering_for_course_name(@course.name)
  #    @first.should == @course
  #end

 # it "for semester should find courses by semester" do
 #   year = Date.today.year
 #   mfse = Factory(:mfse, :semester => "Fall", :year => year )
 #   fse = Factory(:fse, :semester => "Fall", :year => year)
 #   spring_course = Factory(:mfse_current_semester, :semester => "Spring", :year => year)
 #   Course.for_semester("Fall", year)[0].should == fse
 #   Course.for_semester("Fall", year)[1].should == mfse
 #   Course.for_semester("Spring", year)[0].should == spring_course
 #end


  #it "should know which courses are offered this semester" do
  #  list = Course.current_semester_courses
  #  course = Factory(:fse)
  #  list2 = Course.current_semester_courses
  #  list.length.should be_equal list2.length - 1
  #
  #end
  #
  #it "should know which courses are offered next semester" do
  #  list = Course.next_semester_courses
  #  course = Factory(:mfse)
  #  list2 = Course.next_semester_courses
  #  list.length.should be_equal list2.length - 1
  #end

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

  #When modifying this test, please examine the same for team
  context "when adding faculty to a course by providing their names as strings" do
    before(:each) do
       @course = Factory.build(:course)
       @faculty_frank = Factory.build(:faculty_frank, :id => rand(100))
       @faculty_fagan = Factory.build(:faculty_fagan, :id => rand(100) + 100)
       Person.stub(:find_by_human_name).with(@faculty_frank.human_name).and_return(@faculty_frank)
       Person.stub(:find_by_human_name).with(@faculty_fagan.human_name).and_return(@faculty_fagan)
       Person.stub(:find_by_human_name).with("Someone not in the system").and_return(nil)
   end

    it "validates that the people are in the system" do
      @course.faculty_assignments_override = [@faculty_frank.human_name, @faculty_fagan.human_name]
      @course.validate_faculty
      @course.should be_valid
    end

    it "for people not in the system, it sets an error" do
      @course.faculty_assignments_override = [@faculty_frank.human_name, "Someone not in the system", @faculty_fagan.human_name]
      @course.validate_faculty
      @course.should_not be_valid
      @course.errors[:base].should include("Person Someone not in the system not found")
    end

    it "assigns them to the faculty association" do
      @course.faculty_assignments_override = [@faculty_frank.human_name, @faculty_fagan.human_name]
      @course.update_faculty
      @course.faculty[0].should == @faculty_frank
      @course.faculty[1].should == @faculty_fagan
    end
  end


  #context "Last offering" do
  #  it "shouldn't return a class that hasn't happened yet" do
  #    course = Factory(:mfse)
  #    Course.last_offering(course.number).should_not == course
  #
  #
  #  end
  #  it "should return classes last offered" do
  #    course2 = Factory(:fse,:semester => "Summer")
  #    Course.last_offering(course2.number).should == course2
  #    course = Factory(:fse)
  #
  #    Course.last_offering(course.number).should == course
  #  end
  #end

end