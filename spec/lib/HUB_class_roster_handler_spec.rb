require 'spec_helper'

describe HUBClassRosterHandler do
  context "When processing a roster file that lists Sam and Sally as participants in a course," do
    context "and they are not already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew.txt")
        @course = Factory(:mfse)
        @student_sam = Factory(:student_sam)
        @student_sally = Factory(:student_sally)
      end

      it "should add them to the course" do
        #expect { HUBClassRosterHandler.handle(@roster_file) }.to change { Course.find(@course.id).registered_students.count }.from(0).to(2)
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { @course.registered_students.reload.count }.from(0).to(2)
      end


      it "should notify help@sv.cmu.edu about missing students" do
        subject.should_receive(:email_help_about_missing_student).exactly(41).times
        subject.handle(@roster_file)
      end

      it "should notify profs only once" do
        subject.should_receive(:send_emails).exactly(1).times
        subject.handle(@roster_file)
      end

      it "should send the emails" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(42)
      end

    end

    context "and they are already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew.txt")
        @course = Factory.build(:mfse)
        @course.registered_students << @student_sam = Factory(:student_sam_user)
        @course.registered_students << @student_sally = Factory(:student_sally_user)
        @course.save
      end

      it "should not make any changes" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to_not change { @course.registered_students.reload.count }
      end

      it "should notify help@sv.cmu.edu about missing students" do
        subject.should_receive(:email_help_about_missing_student).exactly(41).times
        subject.handle(@roster_file)
      end

      it "should not notify the profs" do
        subject.should_receive(:send_emails).exactly(0).times
        subject.handle(@roster_file)
      end

      it "should send the emails" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(41)
      end
    end
  end

  context "When processing a roster that has no students for a course" do
    before :each do
      @roster_file = File.read("#{Rails.root}/spec/data/student_dropall.txt")
      @course = Factory(:mfse)
      @course.registered_students << @student_sam = Factory(:student_sam_user)
      @course.registered_students << @student_sally = Factory(:student_sally_user)
      @course.faculty << @faculty_frank = Factory(:faculty_frank)
      @course.faculty << @faculty_fagan = Factory(:faculty_fagan)
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
      subject.should_receive(:send_emails).exactly(1).times
      subject.handle(@roster_file)
    end

    it "should send the emails" do
      expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(23)
    end

  end
end