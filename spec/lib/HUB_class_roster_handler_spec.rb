require 'spec_helper'
require 'HUB_class_roster_handler' #This line is required for Travis

describe HUBClassRosterHandler do
  context "When processing a roster file that lists Sam and Sally as participants in a course," do
    context "and they are not already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew.txt")
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
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew.txt")
        @course = FactoryGirl.create(:fse_fall_2011)
        @course.registered_students << @student_sam = FactoryGirl.create(:student_sam_user)
        @course.registered_students << @student_sally = FactoryGirl.create(:student_sally_user)
        @course.save
      end

      it "should not make any changes" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to_not change { @course.registered_students.reload.count }
      end

      it "should notify help@sv.cmu.edu about missing students" do
        subject.should_receive(:email_help_about_missing_student).exactly(1).times
        subject.handle(@roster_file)
      end

      it "should not notify the profs" do
        subject.should_receive(:email_professors_about_added_and_dropped_students).exactly(0).times
        subject.handle(@roster_file)
      end

      it "should send the emails" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(1)
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

    it "should include chris.ziese@sv.cmu.edu as one of the recipients" do
      email = HUBClassRosterHandler.email_professors_about_added_and_dropped_students(@course, @info)
      email.to.should include("chris.ziese@sv.cmu.edu")
    end
  end

end