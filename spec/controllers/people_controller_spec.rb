require "spec_helper"

describe PeopleController do
  context "any user can" do
    before do
      @person1 = FactoryGirl.create(:student_sam_user)
      login(@person1)
      @inactive_person = FactoryGirl.create(:student_sally_user, :is_active => false)
    end

    describe "GET index" do
      it "should assign all active people to people" do
        get :index
        assigns(:people).should == [@person1]
      end

      it "should sort people by name" do
        get :index
        assigns(:people).should == [@person1]
      end
    end

    describe "GET people_search" do
      it "should assign all active people to people" do
        get :search, :filterBoxOne => @person1.first_name
        assigns(:people).should include @person1
      end
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
