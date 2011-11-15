require "spec_helper"

describe PeopleController do
  context "any user can" do
    before do
      @person1 = Factory(:student_sam)
      login(@person1)
      @inactive_person = Factory(:student_sally, :is_active => false)
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
        expect { new_person = Factory.build(:faculty_frank)
        post :create, :person => new_person }.should_not change { Person.count }

      end
    end

    describe "GET edit" do
      it "should render edit page" do
        get :edit, :id => @person1.id
        should render_template("edit")
      end
    end

    describe "GET show_by_twiki failed save" do
      before do
        person = stub_model(Person)
        person.stub(:save).and_return(false)
        Person.stub(:new).and_return(person)
        Person.stub(:parse_twiki).and_return('')
        get :show_by_twiki
      end

      it "should show flash error" do
        flash[:error].should eql 'Person could not be saved.'
      end

      it "should redirect to people" do
        assert_redirected_to people_url
      end
    end

    context "with a bad person id" do
      before do
        Person.stub(:find).and_return(nil)
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