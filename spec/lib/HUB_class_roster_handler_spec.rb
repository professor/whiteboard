require 'spec_helper'
require 'HUB_class_roster_handler' #This line is required for Travis

describe HUBClassRosterHandler do
  context "When processing a roster file that lists Sam and Sally as participants in a course," do
    context "and they are not already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew_with_missing.txt")
        # @older_course = FactoryGirl.create(:fse_fall_2011, :year => 1900)
        @course = FactoryGirl.create(:fse_fall_2011)
        @student_sam = FactoryGirl.create(:student_sam)
        @student_sally = FactoryGirl.create(:student_sally)
      end

      it "should add them to the course" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { @course.registered_students.reload.count }.from(0).to(2)
      end

      it "should add them to the most recent course" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { @course.registered_students.reload.count }.from(0).to(2)
      end

      #it "should add them to the most recent course" do
      #  @older_course = FactoryGirl.create(:mfse, :year => @course.year - 1)
      #  expect { HUBClassRosterHandler.handle(@roster_file) }.to_not change { @older_course }
      #end


      it "should notify help@sv.cmu.edu about missing students" do
        subject.should_receive(:email_help_about_missing_student).exactly(1).times
        subject.handle(@roster_file)
      end

      it "should notify profs only once" do
        subject.should_receive(:email_professors_about_added_and_dropped_students).exactly(1).times
        subject.handle(@roster_file)
      end

      it "should send the emails" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(2)
      end

    end

    context "and they are already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew_with_no_missing.txt")
        @course = FactoryGirl.create(:fse_fall_2011)
        @course.registered_students << @student_sam = FactoryGirl.create(:student_sam_user)
        @course.registered_students << @student_sally = FactoryGirl.create(:student_sally_user)
        @course.save
      end

      it "should not make any changes" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to_not change { @course.registered_students.reload.count }
      end

      it "should not notify the profs" do
        subject.should_receive(:email_professors_about_added_and_dropped_students).exactly(0).times
        subject.handle(@roster_file)
      end

      it "should not send any emails" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end

      context "with a student who is not in the system," do
        before :each do
          @roster_file = File.read("#{Rails.root}/spec/data/student_addnew_with_missing.txt")
        end

        it "should notify help@sv.cmu.edu about missing students" do
          subject.should_receive(:email_help_about_missing_student).exactly(1).times
          subject.handle(@roster_file)
        end

        it "should notify the profs" do
          subject.should_receive(:email_professors_about_added_and_dropped_students).exactly(1).times
          subject.handle(@roster_file)
        end

        it "should send the emails" do
          expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(2)
        end
      end
    end
  end

  context "When processing a roster that has no students for a course" do
    before :each do
      @roster_file = File.read("#{Rails.root}/spec/data/student_dropall.txt")
      @course = FactoryGirl.create(:fse_fall_2011)
      @course.registered_students << @student_sam = FactoryGirl.create(:student_sam_user)
      @course.registered_students << @student_sally = FactoryGirl.create(:student_sally_user)
      @course.faculty << @faculty_frank = FactoryGirl.create(:faculty_frank)
      @course.faculty << @faculty_fagan = FactoryGirl.create(:faculty_fagan)
      @course.save
    end

    it "should drop the students" do
      expect { HUBClassRosterHandler.handle(@roster_file) }.to change { Course.find(@course.id).registered_students.count }.from(2).to(0)
    end


    it "should notify help@sv.cmu.edu about missing students" do
      subject.should_receive(:email_help_about_missing_student).exactly(22).times
      subject.handle(@roster_file)
    end

    it "should notify the profs" do
      subject.should_receive(:email_professors_about_added_and_dropped_students).exactly(1).times
      subject.handle(@roster_file)
    end

    it "should send the emails" do
      expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(23)
    end

  end

  context "When emailing professors about students that were added, dropped or not in system" do
    before :each do
      @course = FactoryGirl.create(:fse_fall_2011)
      @info = { :not_in_system => ['new_student'], :added => [], :dropped => [] }
    end

    it "should include gerry.elizondo@sv.cmu.edu as one of the recipients" do
      email = HUBClassRosterHandler.email_professors_about_added_and_dropped_students(@course, @info)
      email.to.should include("gerry.elizondo@sv.cmu.edu")
    end
  end


  describe "roster_change_message" do
    before :each do
      @course = FactoryGirl.create(:fse_fall_2011)
      @course.save

      @person1 = FactoryGirl.create(:student_sam)
      @person2 = FactoryGirl.create(:student_sally)

      @experimental_feature_text = "** This is an experimental feature. **"
      @official_registration_text = "The official registration list for your course can be <a href='https://acis.as.cmu.edu/grades/'>found here</a>"
      @updating_email_text = "The system will be updating your course mailing list (#{@course.email}) For more information, see your <a href='http://whiteboard.sv.cmu.edu/courses/#{@course.id}'>course tools</a>"

    end

    it "course is nil" do
      message = HUBClassRosterHandler.roster_change_message(nil, nil, nil, nil)

      expected_body = "This email is supposed to contain information about course roster changes, but an error occurred while"
      expected_body += "generating its contents.  Please contact <a href='mailto:todd.sedano@sv.cmu.edu?subject=Roster%20Email%20Error'>Todd Sedano</a>"
      expected_body += "to resolve any issues."

      message.should == expected_body
    end

    it "nil added, dropped, and not_in_system" do
      message = HUBClassRosterHandler.roster_change_message(@course, nil, nil, nil)

      message.should include @experimental_feature_text
      message.should include @official_registration_text
      message.should include @updating_email_text
    end

    it "empty added, dropped, and not_in_system" do
      message = HUBClassRosterHandler.roster_change_message(@course, [], [], [])

      message.should include @experimental_feature_text
      message.should include @official_registration_text
      message.should include @updating_email_text
    end

    it "with added students" do
      @person2.first_name = "<script>cool"
      @person2.last_name = "<script>hacker"
      message = HUBClassRosterHandler.roster_change_message(@course, [@person1, @person2], [], [])
      
      expected_body = "2 students were added to the course:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;#{@person1.first_name} #{@person1.last_name}<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;&lt;script&gt;cool &lt;script&gt;hacker<br/>"

      message.should include @experimental_feature_text
      message.should include @updating_email_text
      message.should include expected_body
    end

    it "with one added student" do
      message = HUBClassRosterHandler.roster_change_message(@course, [@person1], [], [])

      message.should include("1 student was added to the course")
    end

    it "with dropped students" do
      @person2.first_name = "<script>cool"
      @person2.last_name = "<script>hacker"
      message = HUBClassRosterHandler.roster_change_message(@course, [], [@person1, @person2], [])
      
      expected_body = "2 students were dropped from the course:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;#{@person1.first_name} #{@person1.last_name}<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;&lt;script&gt;cool &lt;script&gt;hacker<br/>"

      message.should include @experimental_feature_text
      message.should include @updating_email_text
      message.should include expected_body
    end

    it "with one dropped student" do
      message = HUBClassRosterHandler.roster_change_message(@course, [], [@person1], [])

      message.should include("1 student was dropped from the course")
    end

    it "with students not_in_system" do
      message = HUBClassRosterHandler.roster_change_message(@course, [], [], ["student1", "<script>hacker"])
      
      expected_body = "2 registered students are not in any of our SV systems:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;student1@andrew.cmu.edu<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;&lt;script&gt;hacker@andrew.cmu.edu<br/>"
      expected_body += "We can easily create accounts for these 2 students. Please forward this email to help@sv.cmu.edu indicating which students you want added. (The rails system will create google and twiki accounts.)<br/><br/>"

      message.should include @experimental_feature_text
      message.should include @updating_email_text
      message.should include expected_body
    end

    it "with one student not_in_system" do
      message = HUBClassRosterHandler.roster_change_message(@course, [], [], ["student1"])

      message.should include("1 registered student is not in any of our SV systems")
    end

    it "with students added, dropped and not_in_system" do
      message = HUBClassRosterHandler.roster_change_message(@course, [@person1], [@person2], ["student1", "student2"])
      
      expected_body = "2 registered students are not in any of our SV systems:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;student1@andrew.cmu.edu<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;student2@andrew.cmu.edu<br/>"
      expected_body += "We can easily create accounts for these 2 students. Please forward this email to help@sv.cmu.edu indicating which students you want added. (The rails system will create google and twiki accounts.)<br/><br/>"
      expected_body += "1 student was added to the course:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;#{@person1.first_name} #{@person1.last_name}<br/>"
      expected_body += "1 student was dropped from the course:<br/>"
      expected_body += "&nbsp;&nbsp;&nbsp;#{@person2.first_name} #{@person2.last_name}<br/>"

      message.should include @experimental_feature_text
      message.should include @updating_email_text
      message.should include expected_body
    end
  end
end
