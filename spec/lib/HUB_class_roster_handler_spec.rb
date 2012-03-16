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
        #expect { HUBClassRosterHandler.handle(@roster_file) }.to change { Course.find(@course.id).users.count }.from(0).to(2)
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { @course.users.reload.count }.from(0).to(2)
      end

      it "should notify the profs" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "and they are already in the course," do
      before :each do
        @roster_file = File.read("#{Rails.root}/spec/data/student_addnew.txt")
        @course = Factory.build(:mfse)
        @course.users << @student_sam = Factory(:student_sam)
        @course.users << @student_sally = Factory(:student_sally)
        @course.save
      end

      it "should not make any changes" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to_not change { @course.users.reload.count }
      end

      it "should not notify the profs" do
        expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(0)
      end
    end
  end

  context "When processing a roster that has no students for a course" do
    before :each do
      @roster_file = File.read("#{Rails.root}/spec/data/student_dropall.txt")
      @course = Factory(:mfse)
      @course.users << @student_sam = Factory(:student_sam)
      @course.users << @student_sally = Factory(:student_sally)
      @course.faculty << @faculty_frank = Factory(:faculty_frank)
      @course.faculty << @faculty_fagan = Factory(:faculty_fagan)
      @course.save
    end

    it "should drop the students" do
      expect { HUBClassRosterHandler.handle(@roster_file) }.to change { Course.find(@course.id).users.count }.from(2).to(0)
    end

    it "should notify the profs" do
      expect { HUBClassRosterHandler.handle(@roster_file) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end
  end
end