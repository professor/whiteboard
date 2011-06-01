require 'spec_helper'

describe Person do

  before do
    User.delete_all
    # this list must not be sorted alphabetically
    @faculty_frank = Factory(:faculty_frank)
    @faculty_fagan = Factory(:faculty_fagan)
    @admin_andy = Factory(:admin_andy)
    @student_sam = Factory(:student_sam)
  end

  context "photo upload" do

    it "accepts PNG files" do
      @student_sam.photo = File.new(File.join(Rails.root,'spec','fixtures','sample_photo.png'))
      @student_sam.should be_valid
    end

    it "accepts GIF files" do
      @student_sam.photo = File.new(File.join(Rails.root,'spec','fixtures', "sample_photo.gif"))
      @student_sam.should be_valid
    end

    it "should update image_uri after photo is uploaded" do
      @student_sam.photo = File.new(File.join(Rails.root,'spec','fixtures', "sample_photo.jpg"))
      @student_sam.save!
      @student_sam.image_uri.should eql(@student_sam.photo.url(:profile).split('?')[0])
    end

  end


#  context "is not valid" do
#
#    [:current_allocation, :year, :month, :sponsored_project_allocation_id, :confirmed].each do |attr|
#      it "without #{attr}" do
#        subject.should_not be_valid
#        subject.errors[attr].should_not be_empty
#      end
#    end
#
#    [:actual_allocation, :current_allocation, :year, :month].each do |attr|
#      it "when #{attr} is non-numerical" do
#        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => "test")
#        sponsored_project_effort.should_not be_valid
#      end
#    end
#
#    [:actual_allocation, :current_allocation, :year, :month].each do |attr|
#      it "when #{attr} is a negative number" do
#        sponsored_project_effort = Factory.build(:sponsored_project_effort, attr => -1)
#        sponsored_project_effort.should_not be_valid
#      end
#    end
#
#    it "when a duplicate effort for the same month, year and project allocation" do
#      original = Factory(:sponsored_project_effort)
#      duplicate = SponsoredProjectEffort.new()
#      duplicate.month = original.month
#      duplicate.year = original.year
#      duplicate.sponsored_project_allocation_id = original.sponsored_project_allocation_id
#      duplicate.should_not be_valid
#    end
#  end


  describe 'Custom Finders' do

    it "should have a named scope staff" do
      Person.should respond_to(:staff)
    end

    it 'finds all staff' do
      #Person.staff.should =~ [@admin_andy, @faculty_frank]
      staff = Person.staff
      staff.length.should == 3
      staff.include?(@admin_andy).should be_true
      staff.include?(@faculty_fagan).should be_true
      staff.include?(@faculty_frank).should be_true
    end

    it 'ordered by human name' do
      staff = Person.staff
      staff[0].should == @admin_andy
      staff[1].should == @faculty_fagan
      staff[2].should == @faculty_frank
    end

    it "should have a named scope teachers" do
      Person.should respond_to(:teachers)
    end

    it 'finds all teachers' do
      #Person.staff.should =~ [@faculty_frank]
      teachers = Person.teachers
      teachers.length.should == 2
      teachers.include?(@faculty_fagan).should be_true
      teachers.include?(@faculty_frank).should be_true
    end

    it 'ordered by human name' do
      teachers = Person.teachers
      teachers[0].should == @faculty_fagan
      teachers[1].should == @faculty_frank
    end


  end


  it "should allow for StrengthFinder/StrengthQuest themes" do
    subject.should respond_to(:strength1)
    subject.should respond_to(:strength2)
    subject.should respond_to(:strength3)
    subject.should respond_to(:strength4)
    subject.should respond_to(:strength5)

    user = Factory.build(:strength_quest)
    user.strength1.theme.should be_kind_of(String)
  end

  describe "permission levels" do
    it "can respond to " do
      subject.should respond_to(:permission_level_of)
    end

    it "faculty can do faculty and admin activities" do
      @faculty_frank.permission_level_of(:admin).should == false
      @faculty_frank.permission_level_of(:staff).should == true
      @faculty_frank.permission_level_of(:student).should == true
    end

    it "admin can do all activities" do
      @admin_andy.permission_level_of(:admin).should == true
      @admin_andy.permission_level_of(:staff).should == true
      @admin_andy.permission_level_of(:student).should == true
    end

    it "student can only do student activities" do
      @student_sam.permission_level_of(:admin).should == false
      @student_sam.permission_level_of(:staff).should == false
      @student_sam.permission_level_of(:student).should == true
    end
  end

  describe "emailed_recently" do
    context "for effort logs" do
      it "should be false if they've never received an email" do
        @student_sam.effort_log_warning_email = nil
        @student_sam.emailed_recently(:effort_log).should == false
      end

      it "should be false if they were emailed a while ago" do
        @student_sam.effort_log_warning_email = 4.days.ago
        @student_sam.emailed_recently(:effort_log).should == false
      end

      it "should be true if they were just emailed" do
        @student_sam.effort_log_warning_email = 1.hour.ago
        @student_sam.emailed_recently(:effort_log).should == true
      end
    end

    context "for sponsored project effort" do
      it "should be false if they've never received an email" do
        @student_sam.sponsored_project_effort_last_emailed = nil
        @student_sam.emailed_recently(:sponsored_project_effort).should == false
      end

      it "should be false if they were emailed a while ago" do
        @student_sam.sponsored_project_effort_last_emailed = 4.days.ago
        @student_sam.emailed_recently(:sponsored_project_effort).should == false
      end

      it "should be true if they were just emailed" do
        @student_sam.sponsored_project_effort_last_emailed = 1.hour.ago
        @student_sam.emailed_recently(:sponsored_project_effort).should == true
      end
    end

  end

  context "is versioned" do

    before(:each) do
      @version_number = @student_sam.version
    end

    it "normally" do
      @student_sam.first_name = "New"
      @student_sam.save
      @student_sam.version.should == (@version_number+1)
    end

    it "except when effort log email was sent" do
      @student_sam.effort_log_warning_email = Time.now
      @student_sam.save
      @student_sam.version.should == (@version_number)
    end

    it "except when sponsored project email was sent" do
      @student_sam.sponsored_project_effort_last_emailed = Time.now
      @student_sam.save
      @student_sam.version.should == (@version_number)
    end


  end
  
  describe "person's teams" do

    context "found for each year and semester of person's enrollment" do

    before(:all) do
      activate_authlogic
    end

     before(:each) do
      @team_member = Factory(:student_team_member)
      @team_year = @team_member.teams[0].course.year
      @team_sem = @team_member.teams[0].course.semester
      @pteams = @team_member.find_teams_by_semester(@team_year, @team_sem)
    end

      it "should have a year" do
        @pteams[0].course.year.should == @team_year
      end

      it "should have semester" do
        @pteams[0].course.semester.should == @team_sem
      end

    end

  end

  describe "person's registered courses" do
    before(:each) do
      person_courses = @team_member.get_registered_courses
    end
      it "should be courses for current semester" do
        person_courses[0].semester.should == @team_sem
      end

  end

  # Effort log should only be set for person that is_student - test in effort_log
  # TODO: Graduation_year should be set for person that is_student

end