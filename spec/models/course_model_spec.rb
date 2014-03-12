require 'spec_helper'

describe Course do

  it 'can be created' do
    lambda {
      FactoryGirl.create(:course)
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
      @first = FactoryGirl.create(:course, :semester => "Fall", :year => 2010)
      @third = FactoryGirl.create(:course, :semester => "Summer", :year => 2011)
      @second = FactoryGirl.create(:course, :semester => "Spring", :year => 2011)
      Course.last_offering(@first.number).should == @third
    end
  end


  #it "display name should return the name" do
  #    @course = FactoryGirl.create(:mfse)
  #  result = @course.display_course_name
  #  result.should ==  "MfSESpring2012"
  #end

  #context "Display name" do
  #  it "should display a no short name right" do
  #    course = FactoryGirl.create(:course)
  #    course.display_name.should == "Course"
  #  end
  #  it "should display with a short name correctly" do
  #    course = FactoryGirl.create(:fse)
  #    course.display_name.should == "Foundations of Software Engineering (FSE)"
  #  end
  # it "should show the short name if there is one" do
  #   course = FactoryGirl.create(:fse)
  #   course.short_or_full_name.should == "FSE"
  # end
  #  it "shouldn't show short name if there isn't" do
  #    course = FactoryGirl.create(:course)
  #    course.short_or_full_name.should == "Course"
  #    course = FactoryGirl.create(:fse,:short_name => "")
  #    course.short_or_full_name.should == "Foundations of Software Engineering"
  #  end
  #end
  #
  #
  # context "display semester" do
  #   it "should display semester right" do
  #     course = FactoryGirl.create(:mfse)
  #     course.display_semester.should == "Spring2012"
  #   end
  # end
  #  context "remind about effort" do
  #    it "should remind for mini= both or something" do
  #      course = FactoryGirl.create(:fse, :remind_about_effort => true)
  #      Course.remind_about_effort_course_list[0].should == course
  #    end
  #    it "should remind for mini is not both" do
  #      course2 = FactoryGirl.create(:mfse_current_semester,:remind_about_effort => true, :mini => "A")
  #      Course.remind_about_effort_course_list[0].should == course2
  #    end
  #end

  #it "first_offering_for_course_name should return the first course given one" do
  #    @course = FactoryGirl.create(:mfse)
  #    @first = Course.first_offering_for_course_name(@course.name)
  #    @first.should == @course
  #end

  # it "for semester should find courses by semester" do
  #   year = Date.today.year
  #   mfse = FactoryGirl.create(:mfse, :semester => "Fall", :year => year )
  #   fse = FactoryGirl.create(:fse, :semester => "Fall", :year => year)
  #   spring_course = FactoryGirl.create(:mfse_current_semester, :semester => "Spring", :year => year)
  #   Course.for_semester("Fall", year)[0].should == fse
  #   Course.for_semester("Fall", year)[1].should == mfse
  #   Course.for_semester("Spring", year)[0].should == spring_course
  #end


  #it "should know which courses are offered this semester" do
  #  list = Course.current_semester_courses
  #  course = FactoryGirl.create(:fse)
  #  list2 = Course.current_semester_courses
  #  list.length.should be_equal list2.length - 1
  #
  #end
  #
  #it "should know which courses are offered next semester" do
  #  list = Course.next_semester_courses
  #  course = FactoryGirl.create(:mfse)
  #  list2 = Course.next_semester_courses
  #  list.length.should be_equal list2.length - 1
  #end

  it "should know the start of the course (in cweek)" do
    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010", :mini => 'Both')
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010)

    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Fall", 2010) + 8

    course = FactoryGirl.build(:course, :semester => "Spring", :year => "2010", :mini => 'Both')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = FactoryGirl.build(:course, :semester => "Spring", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010)

    course = FactoryGirl.build(:course, :semester => "Spring", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Spring", 2010) + 9

    course = FactoryGirl.build(:course, :semester => "Summer", :year => "2010", :mini => 'Both')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = FactoryGirl.build(:course, :semester => "Summer", :year => "2010", :mini => 'A')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010)

    course = FactoryGirl.build(:course, :semester => "Summer", :year => "2010", :mini => 'B')
    course.course_start.should == AcademicCalendar.semester_start("Summer", 2010) + 6

  end

  it "should remind effort reports for a particular class with a valid Mini field" do
    valid_course = FactoryGirl.create(:course, :semester => AcademicCalendar.current_semester, :year => Date.today.cwyear, :mini => 'Both', :remind_about_effort => true)
    invalid_course = FactoryGirl.create(:course, :semester => AcademicCalendar.current_semester, :year => Date.today.cwyear, :mini => 'both', :remind_about_effort => true)
    course_list = Course.remind_about_effort_course_list

    course_list.find_index(valid_course).should >= 0
    course_list.find_index(invalid_course).should == nil
  end

  it "should be able to auto_generated_twiki_url" do
    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010", :name => "Foundations of Software Engineering")
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FoundationsofSoftwareEngineering/WebHome"

    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010", :short_name => "FSE")
    course.auto_generated_twiki_url.should == "http://info.sv.cmu.edu/do/view/Fall2010/FSE/WebHome"
  end

  it "should auto_generated_peer_evaluation_date_start" do
    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_start.to_s.should == "2010-10-04"
  end

  it "should auto_generated_peer_evaluation_date_end" do
    course = FactoryGirl.build(:course, :semester => "Fall", :year => "2010")
    course.auto_generated_peer_evaluation_date_end.to_s.should == "2010-10-11"
  end

  it "is versioned" do
    course = FactoryGirl.build(:course)
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

    it "many attributes are copied except 'is_configured' and a few others!" do
      course = FactoryGirl.create(:course, :peer_evaluation_first_email => Date.today)
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
          when "updated_by_user_id"
            new_course.attributes[key].should be_nil
          when "configured_by_user_id"
            new_course.attributes[key].should be_nil
          when "created_at"
            new_course.attributes[key].should_not == value
          when "updated_at"
            new_course.attributes[key].should_not == value
          else
            new_course.attributes[key].should == value
        end
      end
    end

    it "also copies over the people association" do
# Todo: fix this when user and person are the same class
#      course = FactoryGirl.create(:course, :people => [@faculty_frank])
      course = FactoryGirl.create(:course)
      new_course = course.copy_as_new_course
      new_course.save
      new_course.faculty.should == course.faculty
    end

  end

  #context "Last offering" do
  #  it "shouldn't return a class that hasn't happened yet" do
  #    course = FactoryGirl.create(:mfse)
  #    Course.last_offering(course.number).should_not == course
  #
  #
  #  end
  #  it "should return classes last offered" do
  #    course2 = FactoryGirl.create(:fse,:semester => "Summer")
  #    Course.last_offering(course2.number).should == course2
  #    course = FactoryGirl.create(:fse)
  #
  #    Course.last_offering(course.number).should == course
  #  end
  #end


  context 'updates google mailing list' do
    before do
      @course = FactoryGirl.create(:mfse)
      @course.updating_email = false
      @count = Delayed::Job.count
    end

    context 'when the email name changes' do
      before do
        @course.short_name += "_NEW"
        @course.save
      end
      it 'adds an asynchronous request' do
        Delayed::Job.count.should > @count
      end
      it 'marks the state transition' do
        @course.updating_email.should == true
      end
    end

    context 'when the faculty change' do
      before do
        @faculty_frank = FactoryGirl.create(:faculty_frank)
        @course.faculty_assignments_override = [@faculty_frank.human_name]
        @course.save
      end
      it 'adds an asynchronous request' do
        Delayed::Job.count.should > @count
      end
      it 'marks the state transition' do
        @course.updating_email.should == true
      end
    end

    context 'when the registered students change' do
      #This needs to be tested in the HUB importer which manages this
    end

    context 'when the student teams change' do
      #Should be tested by teams spec
    end

    context 'but not when the curriculum url changes' do
      before do
        @course.curriculum_url = "_new_url"
        @course.save
      end
      it 'does not add an asynchronous request' do
        Delayed::Job.count.should == @count
      end
      it 'a state transition does not happen' do
        @course.updating_email.should == false
      end
    end
  end

  context 'nomenclature assignment or deliverable' do
    it "should display the preferred name of assignment" do
      @course_fse = FactoryGirl.create(:fse)
      @course_grading_rule = FactoryGirl.create(:grading_rule_points, :course_id=> @course_fse.id)
      @course_fse.grading_rule = @course_grading_rule

      @course_fse.nomenclature_assignment_or_deliverable.should eql("assignment")
    end

  end

#these tests are the same with team
  context 'generated email address' do
    it 'should use the short name if available' do
      course = FactoryGirl.build(:mfse_fall_2011)
      course.update_email_address
      course.email.should == "fall-2011-mfse@" + GOOGLE_DOMAIN
    end

    it 'should convert unusual characters to ones that google can handle' do
      course = FactoryGirl.build(:mfse_fall_2011)
      course.short_name = "I & E"
      course.update_email_address
      course.email.should == "fall-2011-i-and-e@" + GOOGLE_DOMAIN

    end
  end


  context 'scenario: copy courses from one semester to the next year' do

    context 'given a semesters worth of courses' do
      before(:each) do
        @current_semester_courses = [FactoryGirl.create(:fse_current_semester),
                                     FactoryGirl.create(:mfse_current_semester)]
      end

      context "and there are no courses in the destination semester" do
        context 'when copying the courses in one semester to the next year' do
          before(:each) do
            Course.copy_courses_from_a_semester_to_next_year(AcademicCalendar.current_semester, Date.today.year)
          end

          it 'then the courses are duplicated' do
            future_courses = Course.for_semester(AcademicCalendar.current_semester, Date.today.year + 1)
            future_courses.length.should == @current_semester_courses.length
          end
        end
      end

      it 'should update the peer_evaluation dates, if they are present'
          #when "peer_evaluation_first_email", "peer_evaluation_second_email"
          #  if value.nil?
          #    new_course.attributes[key].should be_nil
          #  else
          #    new_course.attributes[key].should == value + 1.year
          #  end

      context 'and there already exists course' do
        before(:each) do
          next_year = Date.today.year + 1
          @next_year_semester_courses = [FactoryGirl.create(:fse_current_semester, :year => next_year),
                                         FactoryGirl.create(:mfse_current_semester, :year => next_year)]
        end

        it 'then it should not copy over the courses and throws an error' do
          lambda  {
            Course.copy_courses_from_a_semester_to_next_year(AcademicCalendar.current_semester, Date.today.year)
          }.should raise_error

          future_courses = Course.for_semester(AcademicCalendar.current_semester, Date.today.year + 1)
          future_courses.length.should == @next_year_semester_courses.length
          future_courses.length.should_not == @next_year_semester_courses.length + @current_semester_courses.length
        end
      end

    end
  end

  it "email_faculty_to_configure_course sends an email" do
    CourseMailer.should_receive(:configure_course_faculty_email).and_return(double(CourseMailer, :deliver => true))
    course = FactoryGirl.build(:course)
    course.email_faculty_to_configure_course_unless_already_configured
  end

  it "email_faculty_to_configure_course does not sends an email if course is already configured" do
    CourseMailer.should_not_receive(:configure_course_faculty_email)
    course = FactoryGirl.build(:course, :is_configured => true)
    course.email_faculty_to_configure_course_unless_already_configured
  end

  it "registered_students_or_on_teams should list all students in a course" do
    Course.any_instance.stub(:registered_students).and_return([
        stub_model(User, :human_name => "student 1"),
        stub_model(User, :human_name => "student 2")
    ])
    Course.any_instance.stub(:teams).and_return([
        stub_model(Team, :members => [stub_model(User, :human_name => "student 3")] )
    ])
    subject.registered_students_or_on_teams.count.should == 3
  end

  # Tests for has_and_belongs_to_many relationship
  it { should have_many(:faculty) }
  it { should have_many(:registered_students) }

end
