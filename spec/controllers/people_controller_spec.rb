require "spec_helper"

describe PeopleController do
  context "any user can" do
    before do
    
      @alumnus_sean = FactoryGirl.create(:alumnus_sean)
      @alumnus_sunil = FactoryGirl.create(:alumnus_sunil)
      @student_rashmi = FactoryGirl.create(:student_rashmi)
      @student_shama = FactoryGirl.create(:student_shama)
      @student_vidya = FactoryGirl.create(:student_vidya)
      @person1 = FactoryGirl.create(:student_sam_user)
      login(@person1)
      @inactive_person = FactoryGirl.create(:student_sally_user, :is_active => false)
    end

    describe "GET auto_complete" do
      it "should respond with matching names" do
        get :index_autocomplete, :format => :json, :term => "sa"
        parsed_response = JSON.parse(response.body)
        parsed_response.should include "Student Sally", "Student Sam"
      end
    end

# Added my Team Maverick
    describe "GET CSV" do
      it "should export to CSV format" do
        get :index, :format => :csv
        response.body.should include "Name, Email, Telephone1, Telephone2"
        response.body.should include 'Student Sam, student.sam@sv.cmu.edu, 123-456-789, 321-654-987'
      end
    end

    describe "GET VCARD" do
      it "should export to VCARD format" do
        get :index, :format => :vcf
        response.body.should include "BEGIN:VCARD"
        response.body.should include "END:VCARD"
        response.body.should include 'FN: Student Sam'
        response.body.should include 'EMAIL: student.sam@sv.cmu.edu'
        response.body.should include 'TEL;TYPE=Work;VALUE=uri:tel:123-456-789'
        response.body.should include 'TEL;TYPE=Mobile;VALUE=uri:tel:321-654-987'
      end
    end


    describe "Ordered by First Name" do

      it "should orders search results by first name then last name" do
        #@inactive_person.is_active = true;
        get :index, :term => "s"
        assigns(:people).should == [@alumnus_sean, @student_shama, @student_rashmi, @person1, @alumnus_sunil ,@student_vidya]
      end
    end


    describe "GET index" do
      #    Question TODD
      #it "should assign all active people to people" do
      #  get :index
      #  assigns(:people).should == [@person1]
      #end

      #it "should sort people by name" do
      #  get :index
      #  assigns(:people).should == [@person1]
      #end
    end

    describe "GET show" do
      it "should find person by name" do
        get :show, :id => @person1.twiki_name
        assigns(:person).should eql @person1
      end

      it "should find person by id" do
        get :show, :id => @person1.id.to_s
        assigns(:person).should eql @person1
      end
    end

    describe "POST create" do
      it "should not be allowed" do
        expect { new_person = FactoryGirl.build(:faculty_frank_user)
        post :create, :person => new_person }.should_not change { User.count }

      end
    end

    describe "GET edit" do
      it "should render edit page" do
        get :edit, :id => @person1.id
        should render_template("edit")
      end
    end

    context "from the twiki server, the user is not logged in" do
      before do
        controller.stub(:current_user).and_return(nil)
      end
      it "should flash an error" do
        get :show_by_twiki
        flash[:error].should eql "You don't have permissions to view this data."
      end
    end

    context "with a bad person id" do
      before do
        User.stub(:find).and_return(nil)
        @id = 2
      end

      describe "GET my teams" do
        before do
          get :my_teams, :id => @id
        end

        it "should flash error message" do
          flash[:error].should eql 'Person with an id of 2 is not in this system.'
        end

        it "should redirect to people_url" do
          assert_redirected_to people_url
        end
      end

      describe "GET my courses" do
        before do
          get :my_courses, :id => @id
        end

        it "should redirect to people_url" do
          assert_redirected_to people_url
        end

        it "should flash error message" do
          flash[:error].should eql 'Person with an id of 2 is not in this system.'
        end
      end
    end
  end
end
