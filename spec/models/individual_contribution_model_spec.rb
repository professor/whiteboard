require 'spec_helper'

describe IndividualContribution do



  # named scope
  # default sorting order
  # foreign associations with user, year, week_number
 
    it 'can be created' do
      lambda {
        FactoryGirl.create(:individual_contribution)
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
    #      report =  FactoryGirl.create(:individual_contribution)
    #      Date.stub(:today).and_return(Date.parse("Jun 04, 2012")) # which is a Monday.
    #      report.should be_valid
    #
    #  end
    #
    #  it " student cannot update the status report for previous week on any other day" do
    #      report =  FactoryGirl.create(:individual_contribution)
    #      Date.stub(:today).and_return(Date.parse("Jun 05, 2012"))  # which is a Tuesday.
    #      report.should_not be_valid
    #  end
    #
    #
    #  it " Faculty can update the status report for any week on any day of the week" do
    #      report =  FactoryGirl.create(:individual_contribution)
    #      report.should be_valid
    #  end
    #end


    it "should be sorted" do
      @oldest_week = FactoryGirl.create(:individual_contribution, :year => 1983, :week_number => 52)
      @this_week = FactoryGirl.create(:individual_contribution, :user => @oldest_week.user, :year => Date.today.cwyear, :week_number => Date.today.cweek)
      @old_week = FactoryGirl.create(:individual_contribution, :user => @oldest_week.user, :year => 2000, :week_number => 1)
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



  context "combined_answers_for_courses" do
    #Given 3 courses in a semester
    before do
      @student_sam_user = FactoryGirl.create(:student_sam_user)
      @mfse = FactoryGirl.create(:mfse_current_semester)
      @fse = FactoryGirl.create(:fse_current_semester)
      @this_week = FactoryGirl.create(:individual_contribution, :user => @student_sam_user)
      @mfse_answers1 = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @this_week, :course => @mfse, :answer1 => "I did great")
      @fse_answers1 = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @this_week, :course => @fse, :answer1 => "I finished it")

    end
    it "returns an array of hashes. The array corresponds to each question. The hash corresponds to the answer for each course for that question" do
      this_weeks_report = IndividualContribution.find_by_week(@this_week.year, @this_week.week_number, @student_sam_user).combined_answers_for_courses
      this_weeks_report[0].fetch(@mfse.id).should == "I did great"
      this_weeks_report[0].fetch(@fse.id).should == "I finished it"
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
  ##    @effort = FactoryGirl.create(:effort_log)
  ##  end
  ##
  ##  #it "for effort log owner" do
  ##  #  @effort.editable_by(@effort.person).should be_true
  ##  #end
  ##
  ##  it "for admin who is not effort owner" do
  ##    admin_andy = FactoryGirl.create(:admin_andy)
  ##    @effort.person.should_not be_equal(admin_andy)
  ##    @effort.editable_by(admin_andy).should be_true
  ##  end
  ##
  ##  it "not for non admin and non effort log owner" do
  ##    faculty_frank = FactoryGirl.create(:faculty_frank)
  ##    @effort.person.should_not be_equal(faculty_frank)
  ##    @effort.editable_by(faculty_frank).should be_false
  ##  end
  ##end
  #
  #context "has_permission_to_edit_period" do
  #  before(:each) do
  #    @effort = FactoryGirl.create(:effort_log)
  #  end
  #
  #  context "within time period" do
  #    it "for admin who is not effort owner" do
  #      admin_andy = FactoryGirl.create(:admin_andy)
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
  #      faculty_frank = FactoryGirl.create(:faculty_frank)
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
  #      admin_andy = FactoryGirl.create(:admin_andy)
  #      @effort.person.should_not be_equal(admin_andy)
  #      @effort.editable_by(admin_andy).should be_true
  #    end
  #
  #    it "for effort log owner" do
  #      @effort.editable_by(@effort.person).should be_false
  #    end
  #
  #    it "not for non admin and non effort log owner" do
  #      faculty_frank = FactoryGirl.create(:faculty_frank)
  #      @effort.person.should_not be_equal(faculty_frank)
  #      @effort.editable_by(faculty_frank).should be_false
  #    end
  #  end
  #end
  #
  #
  #

  
end
