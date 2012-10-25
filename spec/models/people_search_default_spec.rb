require 'spec_helper'

describe PeopleSearchDefault do

  context "specific users can" do
    before do
      @setech_student = FactoryGirl.create(:student_setech, :is_active => true)
      @phd_student =  FactoryGirl.create(:student_phd, :is_active => true)
      #@staff = FactoryGirl.create(:faculty_frank, :is_active => true)
      @director_of_student_affairs = FactoryGirl.create(:faculty_frank, :is_active => true)
      @phd_advisor = FactoryGirl.create(:faculty_fagan, :is_active => true)
      @admin = FactoryGirl.create(:admin_andy, :is_active => true)

      @visible_to_phd1 = FactoryGirl.create(:people_search_default, :student_staff_group => "Student", :program_group => "PhD", :user_id => @director_of_student_affairs)
      @visible_to_phd2 = FactoryGirl.create(:people_search_default, :student_staff_group => "Student", :program_group => "PhD", :user_id => @phd_advisor)
      #@visible_to_tech = FactoryGirl.create(:person_visible_to_setech, :user_id => @staff)
      #@visible_to_tech = FactoryGirl.create(:person_visible_to_setech, :user_id => @staff)
      #@visible_to_tech = FactoryGirl.create(:person_visible_to_setech, :user_id => @staff)
    end

    #describe "a SE Tech Masters Student should" do
    #  it "should blah" do
    #    login(@setech)
    #    get :index
    #    assigns(:people).should include @visible_to_tech
    #  end
    #end

    describe "when a PhD student is presented a list of default contacts" do
      it "then the defaults should include Gerry and Martin" do
        subject.default_search_results(@phd_student).should include @director_of_student_affairs
      end

      it "then the defaults should not include anyone else" do
      end
    end

  end


end