require 'spec_helper'
require "cancan/matchers"
require "activedirectory/active_directory"


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

  context "can create_active_directory_account" do
    context "get dn" do
      it "returns valid dn for a staff user" do
        @faculty_frank.get_dn.should eq("cn=Faculty Frank,ou=Staff,ou=Sync,dc=cmusv,dc=sv,dc=cmu,dc=local")
      end

      it "returns valid dn for a student user" do
        @student_sam = FactoryGirl.create(:student_sam, masters_program: 'SE')
        @student_sam.get_dn.should eq("cn=Student Sam,ou=SE,ou=Students,ou=Sync,dc=cmusv,dc=sv,dc=cmu,dc=local")
      end
    end

    context "get attributes" do
      it "returns necessary attributes for user account" do
        @faculty_frank.get_attributes.should include(:cn=>"Faculty Frank",
                                                     :mail=>"faculty.frank@sv.cmu.edu",
                                                     :objectclass=>["top", "person", "organizationalPerson", "user"],
                                                     :userPrincipalName=>"faculty.frank")
      end
    end

    it "errors when user has non-google domain email" do
        @student_sam = FactoryGirl.create(:student_sam, email: "student.sam@anyother.sv.cmu.edu")
        @student_sam.create_active_directory_account.should be_is_a(String)
    end

    context "contacts active directory" do

      before do
        @ldap_server = Ladle::Server.new(:quiet => true, :port=>3897).start
        @student_sam = FactoryGirl.create(:student_sam, email: "student.sam@sandbox.sv.cmu.edu")
      end

      after do
        @ldap_server.stop if @ldap_server
      end

      it "carries an operation on active directory" do
        @student_sam.create_active_directory_account.should be_is_a(OpenStruct)
      end

      it "and saves timestamp of account creation on whiteboard" do
        @student_sam.create_active_directory_account
        @student_sam.directory_enabled_at.should be_is_a(Time)
      end
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

  context "should check if profile is valid" do
    before(:each) do
      @student_sam = FactoryGirl.build(:student_sam, is_active: true)
    end
    it "- profile should be invalid if bio/social profile and telephone number fields are missing" do
      @student_sam.send(:update_is_profile_valid)  
      @student_sam.is_profile_valid.should == false
    end
    it "- profile should valid if biography text and one telephone number present" do
      @student_sam.biography = "This is a fake biography. This text should represent pure awesomeness about the individual. populate accordingly."
      @student_sam.telephone1 = "9999999"
      @student_sam.send(:update_is_profile_valid)
      @student_sam.is_profile_valid.should == true
    end
    it "- profile should valid if one social profile and one telephone number present" do
      @student_sam.facebook = "sam_fb_id"
      @student_sam.telephone1 = "9999999"
      @student_sam.send(:update_is_profile_valid)
      @student_sam.is_profile_valid.should == true
    end
    it "notify about missing fields should send out an email" do
      @student_sam.send(:update_is_profile_valid)  
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
      @student_sam.notify_about_missing_field(:biography, "Please update your profile page on whiteboard. You can provide biography information or even just a link to your social profile.")
      ActionMailer::Base.deliveries.size.should == 1
    end
  end

  # carrot and stick functionality
  context "should maintain an updated profile" do
    before(:each) do
      @student_sam = FactoryGirl.create(:student_sam)
      @student_sam.is_profile_valid = false
    end
    it "- student should be redirected if first_access is more than 4 weeks ago" do
      #@student_sam.first_access= DateTime.strptime('01/01/2010 12:00:00', '%d/%m/%Y %H:%M:%S')
      @student_sam.people_search_first_accessed_at = Time.now - 5.weeks
      @student_sam.should_be_redirected?.should == true
    end
    it "- student should not be redirected if first_access is less than 4 weeks ago" do
      @student_sam.people_search_first_accessed_at = Time.now - 3.weeks
      @student_sam.should_be_redirected?.should == false
    end
  end

  describe "notifies when there are expired accounts" do
    before(:each) do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []
    end
    it "should send email to IT about expired accounts within the last month" do
      @student_sam = FactoryGirl.create(:student_sam, is_active: true, expires_at: Date.today - 1.day)
      @student_sally = FactoryGirl.create(:student_sally, is_active: true, expires_at: Date.today - 1.month)
      User.notify_it_about_expired_accounts()
      ActionMailer::Base.deliveries.size.should == 1
      ActionMailer::Base.deliveries.first.to_s.should include Rails.application.routes.url_helpers.user_url(@student_sam, :host => "whiteboard.sv.cmu.edu").to_s
      ActionMailer::Base.deliveries.first.to_s.should include Rails.application.routes.url_helpers.user_url(@student_sally, :host => "whiteboard.sv.cmu.edu").to_s
    end

    it "should NOT send email for accounts that do not expire" do
      @student_sam = FactoryGirl.create(:student_sam, is_active: true, expires_at: nil)
      User.notify_it_about_expired_accounts()
      ActionMailer::Base.deliveries.size.should == 0
    end

    it "should NOT send email for accounts expired more than month ago but should DO send email for accounts expired within one month ago" do
      @student_sam = FactoryGirl.create(:student_sam, is_active: true, expires_at: Date.today - 1.month - 1.day)
      @student_sally = FactoryGirl.create(:student_sally, is_active: true, expires_at: Date.today - 1.month + 1.day)
      User.notify_it_about_expired_accounts()
      ActionMailer::Base.deliveries.size.should == 1
      ActionMailer::Base.deliveries.first.to_s.should_not include Rails.application.routes.url_helpers.user_url(@student_sam, :host => "whiteboard.sv.cmu.edu").to_s
      ActionMailer::Base.deliveries.first.to_s.should include Rails.application.routes.url_helpers.user_url(@student_sally, :host => "whiteboard.sv.cmu.edu").to_s
    end

    it "should NOT send for inactive accounts" do
      @student_sam = FactoryGirl.create(:student_sam, is_active: false, expires_at: Date.today - 1.day)
      User.notify_it_about_expired_accounts()
      ActionMailer::Base.deliveries.size.should == 0
    end

  end

  # More tests
  # Effort log should only be set for person that is_student - tested in effort_log
  # Graduation_year should be set for person that is_student


end
