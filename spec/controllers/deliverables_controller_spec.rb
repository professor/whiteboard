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

    ## beg del turing
=begin
      before(:each) do


        @course = mock_model(Course, :faculty => [@faculty_frank], :course_id => 42)
        @deliverable = stub_model(Deliverable, :course_id => @course.id)

        Deliverable.stub_chain(:where, :all).and_return([@deliverable, @deliverable])

        @course.stub(:grading_rule).and_return(true)
        @course.stub_chain(:grading_rule, :default_values?).and_return(true)
        Course.stub(:find).and_return(@course)
      end

      context "as the faculty owner of the course" do

        before do
          login(@faculty_frank)
        end

        it 'assigns @deliverables' do
          get :grading_queue_for_course, :course_id => @course.id
          assigns(:deliverables).should == [@deliverable, @deliverable]
        end
=end
    ## end del turing

    ## beg add Team turing
    before(:each) do
      @course = FactoryGirl.create(:fse, faculty: [@faculty_frank])

      @assignment_ungraded = FactoryGirl.create(:assignment_1,:course => @course)
      @assignment_drafted = FactoryGirl.create(:assignment_1,:course => @course)
      @assignment_graded = FactoryGirl.create(:assignment_1,:course => @course)

      @turing_grade_graded = FactoryGirl.create(:grade_visible, :course => @course, :student =>@student_sam, :assignment => @assignment_graded)
      @turing_grade_drafted = FactoryGirl.create(:grade_invisible_turing, :course => @course, :student => @student_sam, :assignment =>  @assignment_drafted)
      @turing_grade_ungraded = FactoryGirl.create(:grade_invisible_turing, :course => @course, :student => @student_sam, :assignment =>  @assignment_ungraded)


      @test_grade_ungraded =  FactoryGirl.create(:grade_invisible_turing, :course => @course, :student => @student_sally, :assignment =>  @assignment_graded)

      @team_turing =  FactoryGirl.create(:team_turing, :course=>@course)
      @team_test =  FactoryGirl.create(:team_test, :course=>@course)

      #Needs refactoring, Should work through teams assignments but for some reason it is not.
      @team_turing.members = [@student_sam]
      @team_test.members = [@student_sally]


      #@team_turing_assignment = FactoryGirl.create(:team_turing_assignment, :team => @team_turing, :user => @student_sam)
      #@team_test_assignment = FactoryGirl.create(:team_test_assignment, :team => @team_test, :user => @student_sally)

      @deliverable_turing_ungraded = FactoryGirl.create(:team_turing_deliverable_1,:course => @course, :team => @team_turing,:assignment => @assignment_ungraded)
      @deliverable_turing_drafted = FactoryGirl.create(:team_turing_deliverable_1,:course => @course, :team => @team_turing,:assignment => @assignment_drafted)
      @deliverable_turing_graded = FactoryGirl.create(:team_turing_deliverable_1,:course => @course, :team => @team_turing,:assignment => @assignment_graded)
      @deliverable_test_ungraded = FactoryGirl.create(:team_test_deliverable_1,:course => @course, :team => @team_test,:assignment => @assignment_ungraded)

      @da_turing_ungraded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_ungraded, :submitter => @student_sam)
      @da_turing_drafted =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_drafted, :submitter => @student_sam)
      @da_turing_graded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_turing_graded, :submitter => @student_sam)
      @da_test_ungraded =  FactoryGirl.create(:attachment_1, :deliverable => @deliverable_test_ungraded, :submitter => @student_sam)

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


      #default behavior
      it 'shows ungraded deliverables of only my teams both, team and individual deliverables' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        @expected_deliverable = assigns(:deliverables)

        @expected_deliverable.should have(2).items
        @expected_deliverable[0].should == @deliverable_turing_ungraded
        @expected_deliverable[1].should == @deliverable_turing_drafted
      end

      it 'shows graded deliverables if graded buttons is clicked' do

        subject.instance_variable_set(:@default_deliverables, [@deliverable_turing_ungraded, @deliverable_turing_drafted, @deliverable_turing_graded])

        get :filter_deliverables, :graded => true

        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should have(1).items
        @expected_deliverable[0].should == @deliverable_turing_graded
      end

      it 'shows draft deliverables of only my teams if draft buttons is clicked' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending

      end

      it 'shows graded and ungraded deliverables of only my teams if graded and ungraded buttons are clicked' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending

      end

      it 'shows graded, ungraded and drafted deliverables of only my teams if graded, ungraded and draft buttons are clicked' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending
      end

      it 'shows graded and drafted deliverables of only my teams if graded and draft buttons are clicked' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending
      end

      it 'shows ungraded and drafted deliverables of only my teams if ungraded and draft buttons are clicked' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending
      end

      it 'shows deliverables filtered by deliverable name when deliverable name is selected from dropdown' do
        get :grading_queue_for_course, :course_id =>  @course.id , :faculty_id =>@faculty_frank.id
        pending
      end

      ## end add Team turing

    end


    context "as an admin" do
      before do
        login(@admin_andy)
      end

      it 'assigns @deliverables' do
        get :grading_queue_for_course, :course_id => @course.id
        @expected_deliverable = assigns(:deliverables)
        @expected_deliverable.should == [@deliverable_test_ungraded, @deliverable_turing_graded,
                                         @deliverable_turing_drafted, @deliverable_turing_ungraded]

        ## end chg turing
        pending
      end
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
      @team = stub_model(Team)
      Deliverable.stub(:find).and_return(@deliverable)
      @deliverable.stub(:team).and_return(@team)

      @course.stub(:grading_rule).and_return(true)
      @course.stub_chain(:grading_rule, :default_values?).and_return(true)
      Course.stub(:find).and_return(@course)
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