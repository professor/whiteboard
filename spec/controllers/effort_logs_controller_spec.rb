require 'spec_helper'

describe EffortLogsController do
  context "it should send midweekly reminder email to SE students" do
    it "who have not logged effort" do
      person_who_needs_reminder = Factory(:student_sam, :effort_log_warning_email => Date.today - 1.day)
      Person.stub(:where).and_return([person_who_needs_reminder])
      EffortLog.stub!(:latest_for_person).and_return(nil)

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort[0].should == person_who_needs_reminder.human_name
      people_with_effort.size.should == 0
    end

    it "but skip those who have already been emailed" do
      person_whose_been_reminded = Factory(:faculty_frank, :effort_log_warning_email => Date.today)
      Person.stub(:where).and_return([person_whose_been_reminded])
      EffortLog.stub!(:latest_for_person).and_return(nil)

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort.size.should == 0
      people_with_effort.size.should == 0
    end

    it "and not bother people who have logged effort" do
      person_who_has_logged_effort = Factory(:admin_andy, :effort_log_warning_email => Date.today - 7.days)
      Person.stub(:where).and_return([person_who_has_logged_effort])
      EffortLog.stub(:latest_for_person).and_return(mock_model(EffortLog, :sum => 1))

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort.size.should == 0
      people_with_effort[0].should == person_who_has_logged_effort.human_name
    end

  end
end