require 'spec_helper'

describe StatusReportsController do

  describe "#index" do

    context "when it is the first week of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(1)
        Date.any_instance.stub(:cwyear).and_return(2011)
        login(Factory(:student_sam))
        get(:index)
      end

      specify { assigns(:current_week_number).should == 1 }
      specify { assigns(:previous_week_number).should == 52 }
      specify { assigns(:year).should == 2011 }
      specify { assigns(:previous_week_year).should == 2010 }
    end

    context "when it is not the first week of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(32)
        Date.any_instance.stub(:cwyear).and_return(2011)
        login(Factory(:student_sam))
        get(:index)
      end

      specify { assigns(:current_week_number).should == 32 }
      specify { assigns(:previous_week_number).should == 31 }
      specify { assigns(:year).should == 2011 }
      specify { assigns(:previous_week_year).should == 2011 }
    end

    context "when the day of the week is not Monday" do
      #If we were going to rewrite these tests, consider picking a specific date, and set it
      # Time.stub(:today).and_return(Date.parse("Jun 01 2012"))
      # That way we don't need to know the implementation details of the controller's call to monday?
      before do
        Date.any_instance.stub(:monday?).and_return(false)

      end
      context "and there is no status report" do
        before do
          login(Factory(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link_for_current_week).should be }
        specify { assigns(:show_new_link_for_previous_week).should_not be }
      end

      context "and there are status reports" do
        before do
          @status_reports = [StatusReport.new(:year => 2011, :week_number => 12),
                             StatusReport.new(:year => 2011, :week_number => 11)]
          StatusReport.stub(:find_status_reports).and_return(@status_reports)
          StatusReport.stub(:find_by_week) do |arg1, arg2, arg3|
            case arg2
              when 11
                @status_reports[0]
              when 12
                @status_reports[1]
              else
                nil
            end
          end
        end

        it "and the status reports are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@status_reports[0].year)
          Date.any_instance.stub(:cweek).and_return(@status_reports[0].week_number)
          login(Factory(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should_not be
          assigns(:show_new_link_for_previous_week).should_not be
        end

        it "and the status reports are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@status_reports[0].week_number + 1)
          login(Factory(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should be
          assigns(:show_new_link_for_previous_week).should_not be
        end
      end
    end

    context "when the day of the week is Monday" do
      before do
        Date.any_instance.stub(:monday?).and_return(true)
      end
      context "and there is no status report" do
        before do
          login(Factory(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link_for_current_week).should be }
        specify { assigns(:show_new_link_for_previous_week).should be }
      end

      context "and there are status reports" do
        before do
          @status_reports = [StatusReport.new(:year => 2011, :week_number => 12),
                             StatusReport.new(:year => 2011, :week_number => 11)]
          StatusReport.stub(:find_status_reports).and_return(@status_reports)
          StatusReport.stub(:find_by_week) do |arg1, arg2, arg3|
            case arg2
              when 11
                @status_reports[0]
              when 12
                @status_reports[1]
              else
                nil
            end
          end
        end

        it "and the status reports are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@status_reports[0].year)
          Date.any_instance.stub(:cweek).and_return(@status_reports[0].week_number)
          login(Factory(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should_not be
          assigns(:show_new_link_for_previous_week).should_not be
        end

        it "and the status reports are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@status_reports[0].week_number + 1)
          login(Factory(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should be
          assigns(:show_new_link_for_previous_week).should_not be
        end
      end
    end
  end

#  describe "#create_midweek_warning_email" do
#    before do
#      ScottyDogSaying.stub(:all).and_return([ScottyDogSaying.new(:saying => "random saying")])
#      Person.any_instance.stub(:save).and_return(true)
#    end
#
#    it "it should not send any emails when it is not an status report week" do
#      StatusReport.stub(:log_effort_week?).and_return(false)
#      subject.should_not_receive(:create_midweek_warning_email_send_it)
#      subject.create_midweek_warning_email
#    end
#
#    context "when it is an status report week" do
#      before do
#        StatusReport.stub(:log_effort_week?).and_return(true)
#      end
#
#      context "and there are courses that have students" do
#        before do
#          Course.stub(:remind_about_effort_course_list).and_return([Factory(:mfse)])
#          @person = Person.new(:first_name => "Frodo", :last_name => "Baggins", :human_name => "")
#          Team.stub(:where).and_return([Team.new(:people => [@person])])
#        end
#
#        context "and there are no status reports" do
#          before do
#            StatusReport.stub(:where).and_return([])
##            StatusReport.stub(:log_effort_week?).and_return(true)
#          end
#
#          it "it should send an email if the person has never been emailed" do
#            @person.effort_log_warning_email = nil
#            subject.should_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#
#          it "it should send an email if the person not been emailed recently " do
#            @person.effort_log_warning_email = Time.now - 3.day
#            subject.should_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#
#          it "it should not send an email if the person has been emailed recently" do
#            @person.effort_log_warning_email = Time.now
#            subject.should_not_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#        end
#
#        context "and there are status reports" do
#          context "and the first status reports sums to 0" do
#            before do
#              StatusReport.stub(:where).and_return([StatusReport.new(:sum => 0), Factory(:effort2)])
#            end
#
#          it "it should send an email if the person has never been emailed" do
#            @person.effort_log_warning_email = nil
#            subject.should_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#
#          it "it should send an email if the person not been emailed recently " do
#            @person.effort_log_warning_email = Time.now - 3.day
#            subject.should_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#
#          it "it should not send an email if the person has been emailed recently" do
#            @person.effort_log_warning_email = Time.now
#            subject.should_not_receive(:create_midweek_warning_email_send_it)
#            subject.create_midweek_warning_email
#          end
#          end
#        end
#      end
#    end
#  end
#
#  describe "#create_midweek_warning_email_for_course" do
#    it "it should not throw an error for nil course_id" do
#      subject.create_midweek_warning_email_for_course("random saying", nil)
#    end
#
#    it "it should not throw an error for nil Scotty dog saying" do
#      subject.create_midweek_warning_email_for_course(nil, Factory(:mfse).id)
#    end
#  end
#
#  context "it should send midweekly reminder email to SE students" do
#    it "who have not logged effort" do
#      person_who_needs_reminder = Factory(:student_sam, :effort_log_warning_email => Date.today - 1.day)
#      Person.stub(:where).and_return([person_who_needs_reminder])
#      StatusReport.stub!(:latest_for_person).and_return(nil)
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort[0].should == person_who_needs_reminder.human_name
#      people_with_effort.size.should == 0
#    end
#
#    it "but skip those who have already been emailed" do
#      person_whose_been_reminded = Factory(:faculty_frank, :effort_log_warning_email => Date.today)
#      Person.stub(:where).and_return([person_whose_been_reminded])
#      StatusReport.stub!(:latest_for_person).and_return(nil)
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort.size.should == 0
#      people_with_effort.size.should == 0
#    end
#
#    it "and not bother people who have logged effort" do
#      person_who_has_logged_effort = Factory(:admin_andy, :effort_log_warning_email => Date.today - 7.days)
#      Person.stub(:where).and_return([person_who_has_logged_effort])
#      StatusReport.stub(:latest_for_person).and_return(mock_model(StatusReport, :sum => 1))
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort.size.should == 0
#      people_with_effort[0].should == person_who_has_logged_effort.human_name
#    end
#
#  end
end