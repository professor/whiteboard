require 'spec_helper'
require 'controllers/permission_behavior'

describe GradesController do

  before do
    @admin_andy = FactoryGirl.create(:admin_andy)
    @faculty_frank = FactoryGirl.create(:faculty_frank_user)
    @faculty_fagan = FactoryGirl.create(:faculty_fagan)
    @student_sam = FactoryGirl.create(:student_sam)
    @student_sally = FactoryGirl.create(:student_sally)
    @assign_1 = mock_model(Assignment, :id => 1)
    @course = mock_model(Course, :faculty => [@faculty_frank], :id => 1, :registered_students => [@student_sam, @student_sally], :assignments => [@assign_1, @assignment_2])
    Grade.delete_all
    @grade_sam_assign1   = stub_model(Grade, :course_id => @course.id, :assignment_id => @assign_1.id, :student_id => @student_sam.id, :score => "100")
    @grade_sally_assign1 = stub_model(Grade, :course_id => @course.id, :assignment_id => @assign_1.id, :student_id => @student_sally.id, :score => "100")
    Course.stub(:find).and_return(@course)
  end

  after do
    @admin_andy.delete
    @faculty_frank.delete
    @faculty_fagan.delete
    @student_sam.delete
    @student_sally.delete
  end

  describe "GET index for grades" do

    before(:each) do
      @course.stub(:registered_students_or_on_teams).and_return([@student_sam, @student_sally])
      @course.stub(:teams).and_return([Team.new, Team.new])
      @grading_rule = FactoryGirl.build(:grading_rule)
      @course.stub(:grading_rule).and_return(@grading_rule)
      Grade.stub(:get_grades_for_student_per_course).with(@course, @student_sam).and_return({@assign_1.id => @grade_sam_assign1})
      Grade.stub(:get_grades_for_student_per_course).with(@course, @student_sally).and_return({@assign_1.id => @grade_sally_assign1})
      @expected_grades = {@student_sam => {@assign_1.id => @grade_sam_assign1},
                          @student_sally => {@assign_1.id => @grade_sally_assign1}}
    end

    context "as the faculty owner of the course" do
      before do
        login(@faculty_frank)
      end

      it "assigns @grades" do
        get :index, :course_id => @course.id
        assigns(:grades).should  == @expected_grades
      end
    end

    context "as an admin" do
      before do
        login(@admin_andy)
      end

      it "assigns @grades" do
        get :index, :course_id => @course.id
        assigns(:grades).should  == @expected_grades
      end
    end

    context "as other users" do
      before do
        login(@faculty_fagan)
        get :index, :course_id => @course.id
      end

      it_should_behave_like "permission denied"
    end

  end

  describe "GET student_deliverables_for_course" do
    it 'assigns assignments' do
      login(@student_sam)
      @course = FactoryGirl.build(:course)
      @assignment = FactoryGirl.build(:assignment)
      Course.stub(:find).and_return(@course)
      @course.stub(:assignments).and_return([@assignment])
      get :student_deliverables_and_grades_for_course, :course_id => @course.id
      assigns(:assignments).should == [@assignment]
    end
  end


end
