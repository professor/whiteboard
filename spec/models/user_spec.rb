require 'spec_helper'
require "cancan/matchers"

describe User do

  before do
    User.delete_all
    # this list must not be sorted alphabetically
    @faculty_frank = FactoryGirl.create(:faculty_frank)
    @faculty_fagan = FactoryGirl.create(:faculty_fagan)
    @admin_andy = FactoryGirl.create(:admin_andy)

  end

  describe "abilities" do
    subject { ability }
    let(:ability){ Ability.new(user) }


    context "when is a contracts manager" do
      let(:user){ FactoryGirl.create(:contracts_manager_user) }
      it{ should be_able_to(:manage, SponsoredProjectAllocation.new) }
      it{ should be_able_to(:manage, SponsoredProjectEffort.new) }
      it{ should be_able_to(:manage, SponsoredProjectSponsor.new) }
      it{ should be_able_to(:manage, SponsoredProject.new) }
    end
  end

  describe 'list of user related information' do

    before do
      @student_sam = FactoryGirl.create(:student_sam, :graduation_year=>"2012", :masters_program=>"SE")
    end

    it 'should get list of all graduation years available in the database'  do
      User.get_all_years.should include("2012")
    end
    it 'should get list of all programs available in the database' do
      User.get_all_programs.should include("SE")
    end

  end




  describe "user's teams" do

    it "should format teams" do
      @team_triumphant = FactoryGirl.create(:team_triumphant)
      teams = [@team_triumphant, @team_triumphant]
      subject.formatted_teams(teams).should == "Team Triumphant, Team Triumphant"
#      teams = [FactoryGirl.create(:team, :name => "Team Awesome"), FactoryGirl.create(:team, :name => "Team Beautiful")]
#      subject.formatted_teams(teams).should == "Team Awesome, Team Beautiful"
    end
  end


  context "photo upload" do
    before(:each) do
      @student_sam = FactoryGirl.create(:student_sam)
    end


      it "accepts PNG files" do
        @student_sam.photo = File.new(File.join(Rails.root, 'spec', 'fixtures', 'sample_photo.png'))
        @student_sam.should be_valid
      end

      it "accepts GIF files" do
        @student_sam.photo = File.new(File.join(Rails.root, 'spec', 'fixtures', "sample_photo.gif"))
        @student_sam.should be_valid
      end

      it "should update image_uri after photo is uploaded", :skip_on_build_machine => true do
        @student_sam.photo = File.new(File.join(Rails.root, 'spec', 'fixtures', "sample_photo.jpg"))
        @student_sam.save!
        @student_sam.image_uri.should eql(@student_sam.photo.url(:profile).split('?')[0])
      end

  end

  context "webiso account" do

     it "defaults to user.update_webiso_account if blank" do
       user = User.new
       user.update_webiso_account
       (Time.at(Time.now.to_f) - Time.at(Float(user.webiso_account))).should be < 1.second
     end

   end
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


    end


    it "should allow for StrengthFinder/StrengthQuest themes" do
      subject.should respond_to(:strength1)
      subject.should respond_to(:strength2)
      subject.should respond_to(:strength3)
      subject.should respond_to(:strength4)
      subject.should respond_to(:strength5)

      user = FactoryGirl.build(:strength_quest)
      user.strength1.theme.should be_kind_of(String)
    end

    describe "permission levels" do
      before(:each) do
        @student_sam = FactoryGirl.create(:student_sam)
      end

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
      before(:each) do
        @student_sam = FactoryGirl.create(:student_sam)
      end

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
        @student_sam = FactoryGirl.create(:student_sam)
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

    describe "person's registered courses" do
      # TODO: courses registered - as not tested in the course model

    end

    context "twiki name parsing" do
      it "finds the correct first and last name" do
        twiki_names = {}
        twiki_names["StudentSam"] = ["Student", "Sam"]
        twiki_names["TestUser4"] = ["Test", "User4"]
        twiki_names["DenaHaritosTsamitis"] = ["Dena", "HaritosTsamitis"]
        twiki_names["GordonMcCreight"] = ["Gordon", "McCreight"]

        twiki_names.each do |twiki_name, expected_names|
          names = Person.parse_twiki(twiki_name)
          assert_equal(names[0], expected_names[0])
          assert_equal(names[1], expected_names[1])
        end
      end

    end


    context "can create_google_email(password)" do
      before(:each) do
        @student_sam = FactoryGirl.create(:student_sam)
      end

      it " is successful" do
        ProvisioningApi.any_instance.stub(:create_user).and_return(:some_value)
        password = "just4now"
        @student_sam.email = "student.sam@sandbox.sv.cmu.edu"
        status = @student_sam.create_google_email(password)
        status.should_not be_is_a(String) #If it is a string, should be error message
      end

      it " errors when no email is provided" do
        ProvisioningApi.any_instance.stub(:create_user).and_return("Empty email address")
        password = "just4now"
        @student_sam.email = ""
        status = @student_sam.create_google_email(password)
        status.should == "Empty email address"
        status.should be_is_a(String)
      end
    end


  context "registered_for_these_courses_during_current_semester" do

    it "a student is 'registered' if we have data from the HUB" do
      @student_sam = FactoryGirl.create(:student_sam)
      @course = FactoryGirl.create(:fse_current_semester)
      @student_sam.registered_courses = [@course]
      @student_sam.save
      @student_sam.registered_for_these_courses_during_current_semester.should == [@course]
    end

    it "a student is 'registered' if the faculty has put the student on a team" do
      @team_triumphant = FactoryGirl.create(:team_triumphant)
      @course = @team_triumphant.course
      @student = @team_triumphant.members[0]
      @student.registered_for_these_courses_during_current_semester.should == [@course]
    end


  end

    # More tests
    # Effort log should only be set for person that is_student - tested in effort_log
    # Graduation_year should be set for person that is_student
  context "user should update profile" do
    before(:each) do

      @student_sam = FactoryGirl.create(:student_sam)

      @student_sam.is_profile_valid = false
    end

  it "a student should be redirected if first_access is more than 4 weeks ago" do


    #@student_sam.first_access= DateTime.strptime('01/01/2010 12:00:00', '%d/%m/%Y %H:%M:%S')
    @student_sam.people_search_first_accessed_at = Time.now - 5.weeks


    @student_sam.should_be_redirected?.should == true

  end

  it "a student should not be redirected if first_access is less than 4 weeks ago" do


    @student_sam.people_search_first_accessed_at = Time.now - 3.weeks

    @student_sam.should_be_redirected?.should == false

  end
    end

end
