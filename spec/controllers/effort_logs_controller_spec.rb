require 'spec_helper'

describe EffortLogsController do

  describe "#index" do
    context "when it is the first week of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(1)
        Date.any_instance.stub(:cwyear).and_return(2011)
        login(FactoryGirl.create(:student_sam))
        get(:index)
      end

      specify { assigns(:prior_week_number).should == 52 }
      specify { assigns(:year).should == 2010 }
    end

    context "when it is not the first week of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(32)
        Date.any_instance.stub(:cwyear).and_return(2011)
        login(FactoryGirl.create(:student_sam))
        get(:index)
      end

      specify { assigns(:prior_week_number).should == 31 }
      specify { assigns(:year).should == 2011 }
    end

    context "when the day of the week is Monday" do
      before do
        Date.any_instance.stub(:cwday).and_return(1)
      end
      context "and there is no effort log" do
        before do
          login(FactoryGirl.create(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link).should be }
        specify { assigns(:show_prior_week).should be }
      end

      context "and there are effort logs" do
        before do
          @effort_logs = [EffortLog.new(:year => 2011, :week_number => 12),
                          EffortLog.new(:year => 2011, :week_number => 12)]
          EffortLog.stub(:find_effort_logs).and_return(@effort_logs)
        end

        it "and the effort logs are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@effort_logs[0].year)
          Date.any_instance.stub(:cweek).and_return(@effort_logs[0].week_number)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link).should_not be
          assigns(:show_prior_week).should_not be
        end

        it "and the effort logs are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@effort_logs[0].week_number - 1)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link).should be
          assigns(:show_prior_week).should_not be
        end
      end
    end

    context "when the day of the week is not Monday" do
      before do
        Date.any_instance.stub(:cwday).and_return(3)
      end
      context "and there is no effort log" do
        before do
          login(FactoryGirl.create(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link).should be }
        specify { assigns(:show_prior_week).should_not be }
      end

      context "and there are effort logs" do
        before do
          @effort_logs = [EffortLog.new(:year => 2011, :week_number => 12),
                          EffortLog.new(:year => 2011, :week_number => 12)]
          EffortLog.stub(:find_effort_logs).and_return(@effort_logs)
        end

        it "and the effort logs are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@effort_logs[0].year)
          Date.any_instance.stub(:cweek).and_return(@effort_logs[0].week_number)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link).should_not be
          assigns(:show_prior_week).should_not be
        end

        it "and the effort logs are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@effort_logs[0].week_number - 1)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link).should be
          assigns(:show_prior_week).should_not be
        end
      end
    end
  end

  describe "#create_midweek_warning_email" do
    before do
      ScottyDogSaying.stub(:all).and_return([ScottyDogSaying.new(:saying => "random saying")])
      User.any_instance.stub(:save).and_return(true)
    end

    it "it should not send any emails when it is not an effort log week" do
      EffortLog.stub(:log_effort_week?).and_return(false)
      subject.should_not_receive(:create_midweek_warning_email_send_it)
      subject.create_midweek_warning_email
    end

    context "when it is an effort log week" do
      before do
        EffortLog.stub(:log_effort_week?).and_return(true)
      end

      context "and there are courses that have students" do
        before do
          Course.stub(:remind_about_effort_course_list).and_return([FactoryGirl.create(:mfse)])
          @person = User.new(:first_name => "Frodo", :last_name => "Baggins", :human_name => "")
          Course.any_instance.stub(:registered_students).and_return([@person])
        end

        context "and there are no effort logs" do
          before do
            EffortLog.stub(:where).and_return([])
          end

          it "it should send an email if the person has never been emailed" do
            @person.effort_log_warning_email = nil
            subject.should_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end

          it "it should send an email if the person not been emailed recently " do
            @person.effort_log_warning_email = Time.now - 3.day
            subject.should_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end

          it "it should not send an email if the person has been emailed recently" do
            @person.effort_log_warning_email = Time.now
            subject.should_not_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end
        end

        context "and there are effort logs" do
          context "and the first effort logs sums to 0" do
            before do
              EffortLog.stub(:where).and_return([EffortLog.new(:sum => 0), FactoryGirl.create(:effort2)])
            end

          it "it should send an email if the person has never been emailed" do
            @person.effort_log_warning_email = nil
            subject.should_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end

          it "it should send an email if the person not been emailed recently " do
            @person.effort_log_warning_email = Time.now - 3.day
            subject.should_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end

          it "it should not send an email if the person has been emailed recently" do
            @person.effort_log_warning_email = Time.now
            subject.should_not_receive(:create_midweek_warning_email_send_it)
            subject.create_midweek_warning_email
          end
          end
        end
      end
    end
  end

  describe "#create_midweek_warning_email_for_course" do
    it "it should not throw an error for nil Scotty dog saying" do
      subject.create_midweek_warning_email_for_course(nil, FactoryGirl.create(:mfse).id)
    end
  end

  context "it should send midweekly reminder email to SE students" do
    it "who have not logged effort" do
      person_who_needs_reminder = FactoryGirl.create(:student_sam, :effort_log_warning_email => Date.today - 1.day)
      User.stub(:where).and_return([person_who_needs_reminder])
      EffortLog.stub!(:latest_for_user).and_return(nil)

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort[0].should == person_who_needs_reminder.human_name
      people_with_effort.size.should == 0
    end

    it "but skip those who have already been emailed" do
      person_whose_been_reminded = FactoryGirl.create(:faculty_frank, :effort_log_warning_email => Date.today)
      User.stub(:where).and_return([person_whose_been_reminded])
      EffortLog.stub!(:latest_for_user).and_return(nil)

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort.size.should == 0
      people_with_effort.size.should == 0
    end

    it "and not bother people who have logged effort" do
      person_who_has_logged_effort = FactoryGirl.create(:admin_andy, :effort_log_warning_email => Date.today - 7.days)
      User.stub(:where).and_return([person_who_has_logged_effort])
      EffortLog.stub(:latest_for_user).and_return(mock_model(EffortLog, :sum => 1))

      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
      people_without_effort.size.should == 0
      people_with_effort[0].should == person_who_has_logged_effort.human_name
    end

  end
end
