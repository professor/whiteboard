require "spec_helper"

describe PeopleController do
  context "any user can" do
    before do
      @student_sam = FactoryGirl.create(:student_sam_user, :is_part_time=>'f', :masters_program=>'SE', :is_active=>'t')
      login(@student_sam)
    end

    # describe "GET index" do
    #   it "should assign all active people to people" do
    #     get :index
    #     assigns(:people).should == [@student_sam]
    #   end

    #   it "should sort people by name" do
    #     get :index
    #     assigns(:people).should == [@student_sam]
    #   end
    # end

    describe "GET people#search" do
        before(:each) do
            @faculty_frank = FactoryGirl.create(:faculty_frank_user)
            @student_sally = FactoryGirl.create(:student_sally_user, :is_part_time=>'t', :graduation_year=>'2012', :is_active=>'t')

        end

        # it "should find student_sam_user in the search results" do
        #     get :search, :filterBoxOne => @student_sam.first_name
        #     assigns(:people).should include @student_sam
        # end

        context "students" do
            it "and find students only" do
                get :search, :user_type => "S"
                assigns(:people).should include @student_sam
                assigns(:people).should_not include @faculty_frank
            end
            it "should find active students only" do
                @student_sally.is_active='f'
                @student_sally.save
                get :search, :user_type=>'S'
                assigns(:people).should_not include @student_sally
                assigns(:people).should include @student_sam
            end
            it "and find student Sam, not student Sally" do
                get :search, :user_type => "S", :filterBoxOne => @student_sam.last_name
                assigns(:people).should include @student_sam
                assigns(:people).should_not include @student_sally
            end

            it "should find all full-time students" do
                get :search, :user_type => "SL"
                assigns(:people).should include @student_sam
                assigns(:people).should_not include @student_sally
            end

            it "should find all SE students" do
                get :search, :user_type=>'S', :masters_program => "SE"
                assigns(:people).should include @student_sam
                assigns(:people).should_not include @student_sally
            end
            it "should find all students from class of 2012" do
                get :search, :user_type=>'S', :graduation_year => "2012"
                assigns(:people).should include @student_sally
                assigns(:people).should_not include @student_sam
                assigns(:people).should_not include @faculty_frank
            end
            it "should find inactive students" do
                @student_sally.is_active='f'
                @student_sally.save
                get :search, :user_type=>'S', :search_inactive => "t"
                assigns(:people).should include @student_sally
                assigns(:people).should include @student_sam
            end

            it 'should find all students belonging to a certain course' do
                #pending
                # create course
                # create association
                # get 'S' 'course'
                # assigns should include student
                @course = FactoryGirl.create(:mfse)
                @sally_mfse = FactoryGirl.create(:sally_mfse, :course_id=>@course.id, :user_id => @student_sally.id)
                get :search, :user_type=>'S', :course_id => @course.id
                assigns(:people).should include @student_sally
                assigns(:people).should_not include @student_sam
            end

            it "should find student whose biography contains the word google" do
              @student_sally.biography='has worked at google company'
              @student_sally.save
              get :search, :filterBoxOne=>'google'
              assigns(:people).should include @student_sally
              assigns(:people).should_not include @student_sam
            end

        end



        context "faculty & staff" do
          it "should find faculty only"
          it "should find inactive faculty"
          it "should find staff only"
          it "should find active faculty and staff"
          it "should find inactive faculty and staff"
        end


        #it "should find students who graduated in 2012 from the full-time SE program " do
        #  get :search, :filterBoxOne => @student_sam.first_name
        #  assigns(:people).should include @student_sam
        #end
    end

    describe "GET show" do
      it "should find person by name" do
        get :show, :id => @student_sam.twiki_name
        assigns(:person).should eql @student_sam
      end

      it "should find person by id" do
        get :show, :id => @student_sam.id.to_s
        assigns(:person).should eql @student_sam
      end
    end

    describe "POST create" do
      it "should not be allowed" do
        expect { new_person = FactoryGirl.build(:faculty_frank_user)
        post :create, :person => new_person }.to_not change { User.count }

      end
    end

    describe "check_webiso_account" do
      it "should return true for an existing webiso account" do
        get :ajax_check_if_webiso_account_exists, :q => @student_sam.webiso_account, :format => :json
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["exists"].should == true
      end

      it "should return false for a non-existing webiso account" do
        get :ajax_check_if_webiso_account_exists, :q => "not-in-system", :format => :json
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["exists"].should == false
      end
    end

    describe "check_email" do
      it "should return true for an existing email" do
        get :ajax_check_if_email_exists, :q => @student_sam.email, :format => :json
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["exists"].should == true
      end

      it "should return false for a non-existing email" do
        get :ajax_check_if_email_exists, :q => "not-in-system", :format => :json
        response.should be_success

        json_response = JSON.parse(response.body)
        json_response["exists"].should == false
      end
    end

    describe "GET edit" do
      it "should render edit page" do
        get :edit, :id => @student_sam.id
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
