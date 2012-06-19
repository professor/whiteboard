require 'spec_helper'

describe IndividualContribution do



  # named scope
  # default sorting order
  # foreign associations with user, year, week_number
 
    it 'can be created' do
      lambda {
        Factory(:individual_contribution)
      }.should change(IndividualContribution, :count).by(1)
    end
  
    context "is not valid" do
  
      [:user_id, :year, :week_number].each do |attr|
        it "without #{attr}" do
          subject.should_not be_valid
          subject.errors[attr].should_not be_empty
        end
      end
  
    end

  
    context "associations --" do
      it 'belongs to user' do
        subject.should respond_to(:user)
      end
  
    end

    #context " should update" do
    #
    #  it " student can update the status report for previous week on monday" do
    #      report =  Factory(:individual_contribution)
    #      Date.stub(:today).and_return(Date.parse("Jun 04, 2012")) # which is a Monday.
    #      report.should be_valid
    #
    #  end
    #
    #  it " student cannot update the status report for previous week on any other day" do
    #      report =  Factory(:individual_contribution)
    #      Date.stub(:today).and_return(Date.parse("Jun 05, 2012"))  # which is a Tuesday.
    #      report.should_not be_valid
    #  end
    #
    #
    #  it " Faculty can update the status report for any week on any day of the week" do
    #      report =  Factory(:individual_contribution)
    #      report.should be_valid
    #  end
    #end


    it "should be sorted" do
      @oldest_week = Factory(:individual_contribution, :year => 1983, :week_number => 52)
      @this_week = @oldest_week.dup
      @this_week.update_attributes(:year => Date.today.cwyear, :week_number => Date.today.cweek)
      @old_week = @oldest_week.dup
      @old_week.update_attributes(:year => 2000, :week_number => 1)

      @sorted = IndividualContribution.all
      @sorted.first.should == @this_week
      @sorted.second.should == @old_week
      @sorted.third.should == @oldest_week
    end


  context " it shows the data in an array of arrays" do

    it " shows gets the correct number of courses from the database" do

    end

    it " returns the data in an array of arrays" do
    end
  end



  context "answers" do
    #Given 3 courses in a smemester
    before do
      @mfse = Factory(:mfse_current_semester)
      @fse = Factory(:fse_current_semester)
      @this_week = Factory(:individual_contribution)
      @mfse_answers1 = Factory(:individual_contribution_for_course, :individual_contribution => @this_week.id, :course => @mfse, :answer1 => "I did great")
      @fse_answers1 = Factory(:individual_contribution_for_course, :individual_contribution => @this_week.id, :course => @fse, :answer1 => "I finished it")

    end
    #When method name is called do

    it "returns an array of arrays: question array of course answers" do

      this_weeks_report = IndividualContribution.find_by_week(year, week_number, current_user).answers
      answers[0].get_field(@mfse.id).should_equal "I did great"
      answers[0].get_field(@fse.id).should_equal "I finished it"
    end


  end


  #
  #
  #
  #context 'log_effort_week?' do
  #  it 'should respond to log_effort_week?' do
  #    EffortLog.should respond_to :log_effort_week?
  #  end
  #
  #  it 'it is spring break' do
  #    EffortLog.log_effort_week?(2010, 9).should == false
  #    EffortLog.log_effort_week?(2010, 10).should == false
  #  end
  #
  #  it 'it is not spring break' do
  #    (1..8).each do |week_number|
  #      EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
  #    end
  #    (11..52).each do |week_number|
  #      EffortLog.log_effort_week?(2010, week_number).should == AcademicCalendar.week_during_semester?(2010, week_number)
  #    end
  #  end
  #end
  #
  ##context "has_permission_to_edit" do
  ##  before(:each) do
  ##    @effort = Factory(:effort_log)
  ##  end
  ##
  ##  #it "for effort log owner" do
  ##  #  @effort.editable_by(@effort.person).should be_true
  ##  #end
  ##
  ##  it "for admin who is not effort owner" do
  ##    admin_andy = Factory(:admin_andy)
  ##    @effort.person.should_not be_equal(admin_andy)
  ##    @effort.editable_by(admin_andy).should be_true
  ##  end
  ##
  ##  it "not for non admin and non effort log owner" do
  ##    faculty_frank = Factory(:faculty_frank)
  ##    @effort.person.should_not be_equal(faculty_frank)
  ##    @effort.editable_by(faculty_frank).should be_false
  ##  end
  ##end
  #
  #context "has_permission_to_edit_period" do
  #  before(:each) do
  #    @effort = Factory(:effort_log)
  #  end
  #
  #  context "within time period" do
  #    it "for admin who is not effort owner" do
  #      admin_andy = Factory(:admin_andy)
  #      @effort.person.should_not be_equal(admin_andy)
  #      @effort.editable_by(admin_andy).should be_true
  #    end
  #
  #    it "for effort log owner" do
  #
  #      @effort.editable_by(@effort.person).should be_true
  #    end
  #
  #    it "not for non admin and non effort log owner" do
  #      faculty_frank = Factory(:faculty_frank)
  #      @effort.person.should_not be_equal(faculty_frank)
  #      @effort.editable_by(faculty_frank).should be_false
  #    end
  #  end
  #
  #  context "outside of time period" do
  #    before(:each) do
  #      tenDaysAgo = Date.today-10
  #      @effort.year = tenDaysAgo.year
  #      @effort.week_number = tenDaysAgo.cweek
  #    end
  #
  #    it "for admin who is not effort owner" do
  #      admin_andy = Factory(:admin_andy)
  #      @effort.person.should_not be_equal(admin_andy)
  #      @effort.editable_by(admin_andy).should be_true
  #    end
  #
  #    it "for effort log owner" do
  #      @effort.editable_by(@effort.person).should be_false
  #    end
  #
  #    it "not for non admin and non effort log owner" do
  #      faculty_frank = Factory(:faculty_frank)
  #      @effort.person.should_not be_equal(faculty_frank)
  #      @effort.editable_by(faculty_frank).should be_false
  #    end
  #  end
  #end
  #
  #
  #

  
end
