require 'spec_helper'
require 'controllers/permission_behavior'

describe DeliverablesController do

  before do
    @admin_andy = FactoryGirl.create(:admin_andy)
    @faculty_frank = FactoryGirl.create(:faculty_frank_user)
    @faculty_fagan = FactoryGirl.create(:faculty_fagan)
    @student_sam = FactoryGirl.create(:student_sam)
    @student_sally = FactoryGirl.create(:student_sally)


  end

  describe "GET index for course" do

    ## beg add Team turing
    before(:each) do
      @course = FactoryGirl.create(:fse, faculty: [@faculty_frank])

      @assignment_ungraded = FactoryGirl.create(:assignment_1,:course => @course, :name => "Assignment Ungraded",
                                                :task_number => 1)
      @assignment_drafted = FactoryGirl.create(:assignment_1,:course => @course, :name => "Assignment Drafted",
                                               :task_number => 3)
      @assignment_graded = FactoryGirl.create(:assignment_1,:course => @course, :name => "Assignment Graded",
                                              :task_number => 2)

      @turing_grade_graded = FactoryGirl.create(:grade_visible, :course => @course, :student =>@student_sam,
                                                :assignment => @assignment_graded)
      @turing_grade_drafted = FactoryGirl.create(:grade_invisible, :course => @course, :student => @student_sam,
                                                 :assignment =>  @assignment_drafted)
      @turing_grade_ungraded = nil


     @test_grade_ungraded =  FactoryGirl.create(:grade_invisible_turing, :course => @course,
                                                :student => @student_sally, :assignment =>  @assignment_graded)

      @team_turing =  FactoryGirl.create(:team_turing, :course=>@course)
      @team_test =  FactoryGirl.create(:team_test, :course=>@course)

      @team_turing.members = [@student_sam]
      @team_test.members = [@student_sally]

      @deliverable_turing_ungraded = FactoryGirl.create(:team_turing_deliverable_1,:course => @course,
                              :team => @team_turing,:assignment => @assignment_ungraded, :creator => @student_sam,
                              :grade_status => "ungraded")
      @deliverable_turing_drafted = FactoryGirl.create(:team_turing_deliverable_1,:course => @course,
                              :team => @team_turing,:assignment => @assignment_drafted, :creator => @student_sam,
                              :grade_status => "drafted")
      @deliverable_turing_graded = FactoryGirl.create(:team_turing_deliverable_1,:course => @course,
                              :team => @team_turing,:assignment => @assignment_graded, :creator => @student_sam,
                              :grade_status => "graded")
      @deliverable_test_ungraded = FactoryGirl.create(:team_test_deliverable_1,:course => @course,
                              :team => @team_test,:assignment => @assignment_ungraded, :grade_status => "ungraded")

      @da_turing_ungraded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_ungraded,
                              :submitter => @student_sam)
      @da_turing_drafted =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_drafted,
                              :submitter => @student_sam)
      @da_turing_graded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_graded,
                              :submitter => @student_sam)
      @da_test_ungraded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_test_ungraded,
                              :submitter => @student_sam)

      @course.stub(:grading_rule).and_return(true)
      @course.stub_chain(:grading_rule, :default_values?).and_return(true)
      Course.stub(:find).and_return(@course)

    end

    context "as the faculty owner of the course" do
      before do
        Deliverable.stub(:grading_queue_display).and_return([@deliverable_turing_ungraded, @deliverable_turing_drafted,
                                                             @deliverable_turing_graded])
        login(@faculty_frank)
      end

      it 'shows the assignments names for my course only' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        @expected_assignments = assigns(:assignments)

        @expected_assignments.should have(3).items
        @expected_assignments[0].should == @assignment_ungraded
        @expected_assignments[1].should == @assignment_drafted
        @expected_assignments[2].should == @assignment_graded

      end

      #default behavior
      it 'shows ungraded deliverables of only my teams both, team and individual deliverables' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        @expected_deliverable = assigns(:deliverables)

        @expected_deliverable.should have(2).items
        @expected_deliverable.include?(@deliverable_turing_ungraded).should be_true
        @expected_deliverable.include?(@deliverable_turing_drafted).should be_true
      end

      #default behavior
      it 'shows the deliverables that matches the selected deliverable name' do
        get :get_deliverables, :filter_options => {:graded => "1", :ungraded => "1", :drafted => "1",
            :assignment_id => @assignment_ungraded.id.to_s, :is_my_teams => 'yes', :search_box => ""},
            :course_id =>  @course.id

        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should have(1).items
        @expected_deliverable[0].should == @deliverable_turing_ungraded
      end

      it 'shows graded deliverables if graded buttons is clicked' do
        get :get_deliverables, :filter_options => {:graded => "1", :assignment_id => "-1",
        :is_my_teams => 'yes', :search_box => ""}, :course_id =>  @course.id

        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should have(1).items
        @expected_deliverable[0].should == @deliverable_turing_graded
      end

      it 'shows graded and ungraded deliverables of only my teams if graded and ungraded buttons are clicked' do
        get :get_deliverables, :filter_options => {:graded => "1", :ungraded => "1", :assignment_id => "-1",
        :is_my_teams => 'yes', :search_box => ""}, :course_id =>  @course.id

        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should have(2).items
        @expected_deliverable.include?(@deliverable_turing_graded).should be_true
        @expected_deliverable.include?(@deliverable_turing_ungraded).should be_true

      end

      it 'shows all deliverables of only my teams is clicked' do
        get :get_deliverables, :filter_options => {:assignment_id => "-1", :is_my_teams => 'yes', :search_box => ""},
            :course_id =>  @course.id

        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should have(3).items
        @expected_deliverable.include?(@deliverable_turing_graded).should be_true
        @expected_deliverable.include?(@deliverable_turing_ungraded).should be_true
        @expected_deliverable.include?(@deliverable_turing_drafted).should be_true

      end


      context "search function is enabled" do

        before do

          @team_member = FactoryGirl.create(:team_member)

          @team_ruby_racer = FactoryGirl.create(:team_ruby_racer, :course=>@course)

          @team_ruby_racer.members = [@team_member]

          @ruby_racer_grade_graded = FactoryGirl.create(:grade_visible, :course => @course, :student =>@team_member,
                                                        :assignment => @assignment_graded)
          @ruby_racer_grade_drafted = FactoryGirl.create(:grade_invisible, :course => @course,
                                                         :student => @team_member, :assignment =>  @assignment_drafted)
          @ruby_racer_grade_ungraded = nil

          @deliverable_ruby_racer_ungraded = FactoryGirl.create(:team_ruby_racer_deliverable_1,:course => @course,
                            :team => @team_ruby_racer,:assignment => @assignment_ungraded, :creator => @team_member)
          @deliverable_ruby_racer_drafted = FactoryGirl.create(:team_ruby_racer_deliverable_1,:course => @course,
                            :team => @team_ruby_racer,:assignment => @assignment_drafted, :creator => @team_member)
          @deliverable_ruby_racer_graded = FactoryGirl.create(:team_ruby_racer_deliverable_1,:course => @course,
                            :team => @team_ruby_racer,:assignment => @assignment_graded, :creator => @team_member)

          @da_ruby_racer_ungraded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_ruby_racer_ungraded,
                                    :submitter => @team_member)
          @da_ruby_racer_drafted =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_ruby_racer_drafted,
                                    :submitter => @team_member)
          @da_ruby_racer_graded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_ruby_racer_graded,
                                    :submitter => @team_member)

        end


        it 'shows all deliverables of only my teams and search box is entered' do
          get :get_deliverables, :filter_options => {:assignment_id => "-1", :is_my_teams => 'yes',
                                                     :search_box => "Member"}, :course_id =>  @course.id

          @expected_deliverable = assigns(:deliverables)
          @expected_deliverable.should have(3).items
          @expected_deliverable.include?(@deliverable_ruby_racer_ungraded).should be_true
          @expected_deliverable.include?(@deliverable_ruby_racer_graded).should be_true
          @expected_deliverable.include?(@deliverable_ruby_racer_drafted).should be_true

        end
      end
      ## end add Team turing

    end


    context "as any other user" do
      before do
        login(@faculty_fagan)
        get :grading_queue_for_course, :course_id => @course.id
      end

      it_should_behave_like "permission denied"
    end
  end


  describe "GET my_deliverables" do
    before(:each) do
      @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
      @past_course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 41)
      @deliverable = stub_model(Deliverable, :course_id => @course.id, :owner_id => @student_sam.id)
      @current_assignment = stub_model(Assignment, :course_id => @course.id)
      @past_assignment = stub_model(Assignment, :course_id => @past_course.id)
      Deliverable.stub(:find_current_by_user).and_return([@deliverable, @deliverable])
      Deliverable.stub(:find_past_by_user).and_return([@deliverable, @deliverable])
      Assignment.stub(:list_assignments_for_student).with(@student_sam.id , :current).and_return([@current_assignment])
      Assignment.stub(:list_assignments_for_student).with(@student_sam.id , :past).and_return([@past_assignment])
      Course.stub(:find).and_return(@course)
      User.any_instance.stub(:registered_for_these_courses_during_current_semester).and_return([@course])
      User.any_instance.stub(:registered_for_these_courses_during_past_semesters).and_return([@past_course])
    end

    context "as the owner of the deliverable" do
      before do
        login(@student_sam)
      end

      it 'assigns deliverables' do
        get :my_deliverables, :id => @student_sam.id
        #assigns(:current_deliverables).should == [@deliverable, @deliverable]
        #assigns(:past_deliverables).should == [@deliverable, @deliverable]
        assigns(:current_courses).should == [@course]
        assigns(:past_courses).should == [@past_course]
        assigns(:current_assignments).should == [@current_assignment]
        assigns(:past_assignments).should == [@past_assignment]
      end
    end

    context "as an faculty" do

      before do
        login(@faculty_frank)
      end

      it 'assigns @deliverables' do
        get :my_deliverables, :id => @student_sam.id
        assigns(:current_deliverables).should == [@deliverable, @deliverable]
        assigns(:past_deliverables).should == [@deliverable, @deliverable]
      end
    end

    context "as any other student" do
      before do
        login(@student_sally)
        get :my_deliverables, :id => @student_sam.id
      end

      it_should_behave_like "permission denied for person deliverable"
    end
  end


  describe "GET show" do
    before(:each) do
      @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
      @current_assignment = mock_model(Assignment, :course_id => @course.id, :is_team_deliverable => true)
      @deliverable = stub_model(Deliverable, :course_id => @course.id, :owner_id => @student_sam.id, :assignment=>@current_assignment)
      @deliverable.course = @course
      @team = stub_model(Team)
      Deliverable.stub(:find).and_return(@deliverable)
      @deliverable.stub(:team).and_return(@team)

      @course.stub(:grading_rule).and_return(true)
      @course.stub_chain(:grading_rule, :default_values?).and_return(true)
      @course = Course.stub(:find).and_return(@course)

    end

    context "for a team deliverable" do

      it 'the owner can see it' do
        login(@student_sam)
        @team.stub(:is_user_on_team?).and_return(true)
        get :show, :id => @deliverable.id
        assigns(:deliverable).should == @deliverable
      end

      it "someone else on the team can see it" do
        login(@student_sam)
        @team.stub(:is_user_on_team?).and_return(true)
        get :show, :id => @deliverable.id
        assigns(:deliverable).should == @deliverable
      end

      it "any faculty can see it" do
        login(@faculty_frank)
        @team.stub(:is_user_on_team?).and_return(false)
        get :show, :id => @deliverable.id
        assigns(:deliverable).should == @deliverable
      end

      context "no other student can see it" do
        before do
          @team.stub(:is_user_on_team?).and_return(false)
          login(@student_sally)
          get :show, :id => @deliverable.id
        end

        it_should_behave_like "permission denied for person deliverable"
      end
    end
  end


#    describe "GET edit" do
#
#      it 'assigns @efforts' do
#        efforts = [stub_model(SponsoredProjectEffort)]
#        SponsoredProjectEffort.should_receive(:month_under_inspection_for_a_given_user).with(@faculty_frank.id).and_return(efforts)
#        get :edit, :id => @faculty_frank.twiki_name
#        assigns(:efforts).should == efforts
#        assigns(:month).should == efforts[0].month
#        assigns(:year).should == efforts[0].year
#      end
#    end
#
#    describe "PUT update" do
#
#      before(:each) do
#        @effort_1 = stub_model(SponsoredProjectEffort)
#        @effort_2 = stub_model(SponsoredProjectEffort)
#
#        @effort_1.stub(:valid).and_return(true)
#        @effort_2.stub(:valid).and_return(true)
#
#        @effort_1.stub(:unique_month_year_allocation_id?).and_return(true)
#        @effort_2.stub(:unique_month_year_allocation_id?).and_return(true)
#
#        SponsoredProjectEffort.should_receive(:find).with("0").and_return(@effort_1)
#        SponsoredProjectEffort.should_receive(:find).with("1").and_return(@effort_2)
#
#        subject.should_receive(:setup_edit).and_return(true)
#
#        SponsoredProjectEffort.stub(:emails_business_manager)
#      end
#
#
#      describe "with valid params" do
#
#        it "updates the actual allocations" do
#          @effort_1.should_receive(:actual_allocation=).with("25")
#          @effort_2.should_receive(:actual_allocation=).with("75")
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#        end
#
#        it 'updates the confirmed value' do
#          @effort_1.should_receive(:confirmed=).with(true)
#          @effort_2.should_receive(:confirmed=).with(true)
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#        end
#
##        it 'sets the flash' do
##          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
##          flash.now[:notice].should_not be_nil
##        end
#
#        it "re-renders the 'edit' template" do
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#          response.should render_template("edit")
#        end
#
#        it "emails the business manager when actual != confirmed" do
#          SponsoredProjectEffort.should_receive(:emails_business_manager)
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#        end
#      end
#
#      describe "with invalid params" do
#
#        it 'sets the flash to error' do
#          @effort_2.should_receive(:save).and_return(false)
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#          assigns(:failed).should == true
#          #flash.now[:error].should == "Your allocations did not save."
#        end
#
#        it "re-renders the 'edit' template" do
#          @effort_2.should_receive(:save).and_return(false)
#          put :update, :id => "AndrewCarnegie", :effort_id_values => {"0" => "25", "1" => "75"}
#          response.should render_template("edit")
#        end
#      end
#    end


end