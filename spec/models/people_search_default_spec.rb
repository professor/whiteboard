require 'spec_helper'

describe PeopleSearchDefault do

  context "specific users can" do

    before do

      #define a set of user objects to use in tests of this context.
      @setech_student = FactoryGirl.create(:student_setech_user, :is_active => true)
      @phd_student =  FactoryGirl.create(:student_phd_user, :is_active => true)
      @director_of_student_affairs = FactoryGirl.create(:faculty_frank_user, :is_active => true)
      @phd_advisor = FactoryGirl.create(:faculty_fagan_user, :is_active => true)
      @staff = FactoryGirl.create(:contracts_manager_user, :is_active => true)
      @admin = FactoryGirl.create(:admin_andy_user, :is_active => true)

      #set up relationships defining default contacts for users.
      @visible_to_all_users = FactoryGirl.create(:people_search_default, :student_staff_group => "All", :user => @admin)
      @visible_to_all_students = FactoryGirl.create(:people_search_default, :student_staff_group => "Student", :program_group => "All", :user => @director_of_student_affairs)
      @visible_to_staff = FactoryGirl.create(:people_search_default, :student_staff_group => "Staff", :user => @staff)
      @visible_to_phd = FactoryGirl.create(:people_search_default, :student_staff_group => "Student", :program_group => "PhD", :user => @phd_advisor)
      @visible_to_setech = FactoryGirl.create(:people_search_default, :student_staff_group => "Student", :program_group => "SE", :track_group => "Tech", :user => @staff)

    end

    describe "when a PhD student is presented a list of default contacts" do

      it "then the defaults should include Admin Andy, Director of Student Affairs, and PhD Advisor" do
        search_results = PeopleSearchDefault.default_search_results(@phd_student)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should include @admin.id
        search_results.should include @director_of_student_affairs.id
        search_results.should include @phd_advisor.id
      end

      it "then the defaults should not include anyone else" do
        search_results = PeopleSearchDefault.default_search_results(@phd_student)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should_not include @staff.id
      end
    end

    describe "when a SE Tech student is presented a list of default contacts" do

      it "then the defaults should include Admin Andy, Director of Student Affairs, and other appropriate staff members" do
        search_results = PeopleSearchDefault.default_search_results(@setech_student)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should include @admin.id
        search_results.should include @director_of_student_affairs.id
        search_results.should include @staff.id
      end

      it "then the defaults should not include anyone else" do
        search_results = PeopleSearchDefault.default_search_results(@setech_student)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should_not include @phd_advisor.id
      end

    end

    describe "when a staff member is presented a list of default contacts" do

      it "then the defaults should include Admin Andy and other appropriate staff members" do
        search_results = PeopleSearchDefault.default_search_results(@staff)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should include @admin.id

        search_results = PeopleSearchDefault.default_search_results(@director_of_student_affairs)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should include @staff.id

      end

      it "then the defaults should not include anyone else" do
        search_results = PeopleSearchDefault.default_search_results(@staff)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should_not include @phd_advisor.id
      end
    end

    describe "when a user is presented a list of default contacts" do
      it "they should not see their own contact info" do
        search_results = PeopleSearchDefault.default_search_results(@staff)
        search_results = search_results.collect{ |result| result.user_id }
        search_results.should_not include @staff.id
      end

    end

  end
end
