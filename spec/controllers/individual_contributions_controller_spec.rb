require 'spec_helper'

describe IndividualContributionsController do

  describe "#index" do

    context "when it is the first week of the year" do
      before do
        Date.any_instance.stub(:cweek).and_return(1)
        Date.any_instance.stub(:cwyear).and_return(2011)
        login(FactoryGirl.create(:student_sam))
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
        login(FactoryGirl.create(:student_sam))
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
      context "and there is no individual contribution" do
        before do
          login(FactoryGirl.create(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link_for_current_week).should be }
        specify { assigns(:show_new_link_for_previous_week).should_not be }
      end

      context "and there are individual contributions" do
        before do
          @individual_contributions = [IndividualContribution.new(:year => 2011, :week_number => 12),
                                       IndividualContribution.new(:year => 2011, :week_number => 11)]
          IndividualContribution.stub(:find_individual_contributions).and_return(@individual_contributions)
          IndividualContribution.stub(:find_by_week) do |arg1, arg2, arg3|
            case arg2
              when 11
                @individual_contributions[0]
              when 12
                @individual_contributions[1]
              else
                nil
            end
          end
        end

        it "and individual contributions are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@individual_contributions[0].year)
          Date.any_instance.stub(:cweek).and_return(@individual_contributions[0].week_number)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should_not be
          assigns(:show_new_link_for_previous_week).should_not be
        end

        it "and individual contributions are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@individual_contributions[0].week_number + 1)
          login(FactoryGirl.create(:student_sam))
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
      context "and there is no individual contribution" do
        before do
          login(FactoryGirl.create(:student_sam))
          get(:index)
        end
        specify { assigns(:show_new_link_for_current_week).should be }
        specify { assigns(:show_new_link_for_previous_week).should be }
      end

      context "and there are individual contributions" do
        before do
          @individual_contributions = [IndividualContribution.new(:year => 2011, :week_number => 12),
                                       IndividualContribution.new(:year => 2011, :week_number => 11)]
          IndividualContribution.stub(:find_individual_contributions).and_return(@individual_contributions)
          IndividualContribution.stub(:find_by_week) do |arg1, arg2, arg3|
            case arg2
              when 11
                @individual_contributions[0]
              when 12
                @individual_contributions[1]
              else
                nil
            end
          end
        end

        it "and the individual contributions are in the current period" do
          Date.any_instance.stub(:cwyear).and_return(@individual_contributions[0].year)
          Date.any_instance.stub(:cweek).and_return(@individual_contributions[0].week_number)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should_not be
          assigns(:show_new_link_for_previous_week).should_not be
        end

        it "and the individual contributions are not in the current period" do
          Date.any_instance.stub(:cweek).and_return(@individual_contributions[0].week_number + 1)
          login(FactoryGirl.create(:student_sam))
          get(:index)
          assigns(:show_new_link_for_current_week).should be
          assigns(:show_new_link_for_previous_week).should_not be
        end
      end
    end
  end

  describe "#edit" do

    it "assigns a list of questions" do
      login(FactoryGirl.create(:student_sam_user))
      get(:edit)
      assigns(:questions).should be_a_kind_of(Array)
    end

    it "assigns a list of the user's registered courses for the current mini" do
      login(FactoryGirl.create(:student_sam_user_with_registered_courses))
      get(:edit)
      courses = assigns(:courses)
      courses.each { |course| course.current_mini?.should be_true }
    end


    it "assigns a list of input types telling the ui whether to use an input text area or an input field" do
      login(FactoryGirl.create(:student_sam_user))
      get(:edit)
      assigns(:answer_input_types).should be_a_kind_of(Array)
    end

    context "for a user" do
      before do
        @student_sam_user = FactoryGirl.create(:student_sam_user)
        login(@student_sam_user)
        @fse = FactoryGirl.create(:fse_current_semester)
        @mfse = FactoryGirl.create(:mfse_current_semester)
      end

      it "when there is previous week data, then assigns the student's plan for the current week" do
        @previous_week = FactoryGirl.create(:individual_contribution, :user => @student_sam_user, :week_number => Date.today.cweek - 1, :year => Date.today.cwyear)
        @mfse_previous_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @previous_week, :course => @mfse, :answer5 => "I did great")
        @fse_previous_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @previous_week, :course => @fse, :answer5 => "I finished it")
        get(:edit)

        assigns(:plans_from_previous_week).should == {@mfse.id => "I did great", @fse.id => "I finished it"}
      end

      # As an example, if there were only two questions, the data structure would look like this:
      # [ { course_id => answer 1, course_id => answer 1}, {course_id => answer 2, course_id => answer 2}]
      #
      it "assigns an array of hashes for each student" do
        @current_week = FactoryGirl.create(:individual_contribution, :user => @student_sam_user, :week_number => Date.today.cweek, :year => Date.today.cwyear)
        @mfse_current_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @current_week, :course => @mfse,
                                            :answer1 => "I dreamed a dream",
                                            :answer2 => "40.5",
                                            :answer3 => "Only the speed of light is my obstacle",
                                            :answer4 => "Get really really small",
                                            :answer5 => "I will take over the world")
        @fse_current_answers = FactoryGirl.create(:individual_contribution_for_course, :individual_contribution => @current_week, :course => @fse,
                                           :answer1 => "I want a job",
                                           :answer2 => "30.5",
                                           :answer3 => "Algorithms is my obstacle",
                                           :answer4 => "study study and study",
                                           :answer5 => "take a vacation")
        get(:edit)

        assigns(:answers_for_this_week).should == [{@mfse.id => "I dreamed a dream", @fse.id => "I want a job"},
                                                   {@mfse.id => 40.5, @fse.id => 30.5},
                                                   {@mfse.id => "Only the speed of light is my obstacle", @fse.id => "Algorithms is my obstacle"},
                                                   {@mfse.id => "Get really really small", @fse.id => "study study and study"},
                                                   {@mfse.id => "I will take over the world", @fse.id => "take a vacation"}]


      end

    end

  end


#  describe "#create_midweek_warning_email" do
#    before do
#      ScottyDogSaying.stub(:all).and_return([ScottyDogSaying.new(:saying => "random saying")])
#      Person.any_instance.stub(:save).and_return(true)
#    end
#
#    it "it should not send any emails when it is not an individual contribution week" do
#      IndividualContribution.stub(:log_effort_week?).and_return(false)
#      subject.should_not_receive(:create_midweek_warning_email_send_it)
#      subject.create_midweek_warning_email
#    end
#
#    context "when it is an individual contribution week" do
#      before do
#        IndividualContribution.stub(:log_effort_week?).and_return(true)
#      end
#
#      context "and there are courses that have students" do
#        before do
#          Course.stub(:remind_about_effort_course_list).and_return([FactoryGirl.create(:mfse)])
#          @person = Person.new(:first_name => "Frodo", :last_name => "Baggins", :human_name => "")
#          Team.stub(:where).and_return([Team.new(:people => [@person])])
#        end
#
#        context "and there are no individual contributions" do
#          before do
#            IndividualContribution.stub(:where).and_return([])
##            IndividualContribution.stub(:log_effort_week?).and_return(true)
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
#        context "and there are individual contributions" do
#          context "and the first individual contributions sums to 0" do
#            before do
#              IndividualContribution.stub(:where).and_return([IndividualContribution.new(:sum => 0), FactoryGirl.create(:effort2)])
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
#      subject.create_midweek_warning_email_for_course(nil, FactoryGirl.create(:mfse).id)
#    end
#  end
#
#  context "it should send midweekly reminder email to SE students" do
#    it "who have not logged effort" do
#      person_who_needs_reminder = FactoryGirl.create(:student_sam, :effort_log_warning_email => Date.today - 1.day)
#      Person.stub(:where).and_return([person_who_needs_reminder])
#      IndividualContribution.stub!(:latest_for_person).and_return(nil)
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort[0].should == person_who_needs_reminder.human_name
#      people_with_effort.size.should == 0
#    end
#
#    it "but skip those who have already been emailed" do
#      person_whose_been_reminded = FactoryGirl.create(:faculty_frank, :effort_log_warning_email => Date.today)
#      Person.stub(:where).and_return([person_whose_been_reminded])
#      IndividualContribution.stub!(:latest_for_person).and_return(nil)
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort.size.should == 0
#      people_with_effort.size.should == 0
#    end
#
#    it "and not bother people who have logged effort" do
#      person_who_has_logged_effort = FactoryGirl.create(:admin_andy, :effort_log_warning_email => Date.today - 7.days)
#      Person.stub(:where).and_return([person_who_has_logged_effort])
#      IndividualContribution.stub(:latest_for_person).and_return(mock_model(IndividualContribution, :sum => 1))
#
#      (people_without_effort, people_with_effort) = subject.create_midweek_warning_email_for_se_students("random saying")
#      people_without_effort.size.should == 0
#      people_with_effort[0].should == person_who_has_logged_effort.human_name
#    end
#
#  end
end