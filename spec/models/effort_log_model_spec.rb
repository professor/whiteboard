require 'spec_helper'

describe EffortLog do

  context 'log_effort_week?' do
    it 'should respond to log_effort_week?' do
      EffortLog.should respond_to :log_effort_week?
    end

    it 'it is spring break' do
      EffortLog.log_effort_week?(2010, 9).should == false
      EffortLog.log_effort_week?(2010, 10).should == false
    end

    it 'it is not spring break' do
      (1..8).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
      (11..52).each do |week_number|
        EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
      end
    end
  end

  context "is not valid" do
    [:user, :week_number, :year].each do |attr|
      it "without #{attr}" do
        subject.should_not be_valid
        subject.errors[attr].should_not be_empty
      end
    end    
  end

  #context "has_permission_to_edit" do
  #  before(:each) do
  #    @effort = FactoryGirl.create(:effort_log)
  #  end
  #
  #  #it "for effort log owner" do
  #  #  @effort.editable_by(@effort.user).should be_true
  #  #end
  #
  #  it "for admin who is not effort owner" do
  #    admin_andy = FactoryGirl.create(:admin_andy)
  #    @effort.user.should_not be_equal(admin_andy)
  #    @effort.editable_by(admin_andy).should be_true
  #  end
  #
  #  it "not for non admin and non effort log owner" do
  #    faculty_frank = FactoryGirl.create(:faculty_frank)
  #    @effort.user.should_not be_equal(faculty_frank)
  #    @effort.editable_by(faculty_frank).should be_false
  #  end
  #end

  context "has_permission_to_edit_period" do
    before(:each) do
      @effort = FactoryGirl.create(:effort_log)
    end

    context "within time period" do
      it "for admin who is not effort owner" do
        admin_andy = FactoryGirl.create(:admin_andy)
        @effort.user.should_not be_equal(admin_andy)
        @effort.editable_by(admin_andy).should be_true
      end

      it "for effort log owner" do

        @effort.editable_by(@effort.user).should be_true
      end

      it "not for non admin and non effort log owner" do
        faculty_frank = FactoryGirl.create(:faculty_frank)
        @effort.user.should_not be_equal(faculty_frank)
        @effort.editable_by(faculty_frank).should be_false
      end
    end

    context "outside of time period" do
      before(:each) do
        tenDaysAgo = Date.today-10
        @effort.year = tenDaysAgo.year
        @effort.week_number = tenDaysAgo.cweek
      end

      it "for admin who is not effort owner" do
        admin_andy = FactoryGirl.create(:admin_andy)
        @effort.user.should_not be_equal(admin_andy)
        @effort.editable_by(admin_andy).should be_true
      end

      it "for effort log owner" do
        @effort.editable_by(@effort.user).should be_false
      end

      it "not for non admin and non effort log owner" do
        faculty_frank = FactoryGirl.create(:faculty_frank)
        @effort.user.should_not be_equal(faculty_frank)
        @effort.editable_by(faculty_frank).should be_false
      end
    end
  end

  context "validate_effort_against_registered_courses where user" do
    before(:each) do
      @effort_log_line_item = FactoryGirl.create(:elli_line1)
      @effort = FactoryGirl.create(:effort_log, :effort_log_line_items => [@effort_log_line_item])
    end

    it "is signed up for the course" #do
#      user = @effort.user
#      courses = [@effort_log_line_item.course]
#      user.should_receive(:get_registered_courses).and_return(courses)
#
#      error_message = @effort.validate_effort_against_registered_courses
#      puts error_message
#      error_message.should == "" #no error
#    end

    it "is not signed up for the course" #do
#      user = @effort.user
#      courses = []
#      user.should_receive(:get_registered_courses).and_return(courses)
#
#      error_message = @effort.validate_effort_against_registered_courses
#      error_message.should == @effort_log_line_item.course.name
#    end
    
  end

	describe '.users_with_effort_against_unregistered_courses' do
    before do
      @effort = FactoryGirl.create(:effort_log, :effort_log_line_items => [FactoryGirl.create(:elli_line1)])
    end

    context 'with courses in error' do
      before do
        EffortLog.any_instance.stub(:validate_effort_against_registered_courses).and_return("No course selected")
      end
      it 'returns the errors for each user' do
        EffortLog.users_with_effort_against_unregistered_courses.should == {@effort.user => "No course selected"}
      end
    end

    context 'with no courses in error' do
      before do
        EffortLog.any_instance.stub(:validate_effort_against_registered_courses).and_return("")
      end
      it 'returns nothing' do
        EffortLog.users_with_effort_against_unregistered_courses.should == {}
      end
    end
  end

  describe '#determine_total_effort' do
    before do
      @effort = FactoryGirl.create(:effort_log, :effort_log_line_items => [FactoryGirl.create(:elli_line1, :day6 => 10)])
      @effort.determine_total_effort
    end
    it 'sets the total effort sum' do
      @effort.sum.should == 34
    end
  end

  
end
