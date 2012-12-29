require 'spec_helper'
require 'controllers/permission_behavior'

describe CoursesController do


  let(:course) { FactoryGirl.create(:course) }

  shared_examples_for "courses_for_a_given_semester" do
    specify { assigns(:courses).should_not be_nil }
    specify { assigns(:semester).should_not be_nil }
    specify { assigns(:year).should_not be_nil }
    specify { assigns(:all_courses).should == false }
  end

  context "any user can" do
    before do
      login(FactoryGirl.create(:student_sam))
    end

    describe "GET index for semester" do
      before do
        FactoryGirl.create(:course, :mini => "A")
        FactoryGirl.create(:course, :mini => "B")
        FactoryGirl.create(:course, :mini => "Both")
        get :index_for_semester, :semester => "Fall2012"
      end

      specify { assigns(:semester_length_courses).should_not be_nil }
      specify { assigns(:mini_a_courses).should_not be_nil }
      specify { assigns(:mini_b_courses).should_not be_nil }

      it_should_behave_like "courses_for_a_given_semester"
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:courses).should_not be_nil }
      specify { assigns(:all_courses).should == true }
    end

    describe "GET show" do
      before do
        get :show, :id => course.to_param
      end

      specify { assigns(:course).should_not be_nil }
      specify { assigns(:emails).should_not be_nil }

    end

    describe "not GET new" do
      before do
        get :new
      end

      it_should_behave_like "cancan permission denied"
    end


    describe "not GET configure" do
      before do
        get :configure, :id => course.to_param
      end

      it_should_behave_like "cancan permission denied"
    end

    describe "not POST create" do
      before do
        @course = FactoryGirl.build(:course)
        post :create, :course => @course.attributes
      end

      it_should_behave_like "cancan permission denied"
    end

    describe "not PUT update" do
      before do
        put :update, :id => course.to_param, :course => {:name => 'NNNNN'}
      end

      it_should_behave_like "cancan permission denied"
    end

    describe "not DELETE destroy" do
      before do
        delete :destroy, :id => course.to_param
      end

      it_should_behave_like "permission denied"
    end

  end

  context "any staff can" do
    before do
      login(FactoryGirl.create(:faculty_frank))
    end

    describe "GET new" do
      before do
        get :new
      end

      specify { assigns(:course).should_not be_nil }
    end

    describe "GET edit" do
      before do
        get :edit, :id => course.to_param
      end

      specify { assigns(:course).should == course }
    end

    describe "GET configure" do
      before do
        get :configure, :id => course.to_param
      end

      specify { assigns(:course).should == course }
    end


    describe "POST create" do

      describe "with valid params for new course number" do
        before(:each) do
          @course = FactoryGirl.build(:course)
        end

        it "saves a newly created item" do
          lambda {
            post :create, :course => {"number"=>"96-NEW", "semester"=>"Summer", "year"=>"2011"}
          }.should change(Course, :count).by(1)
        end

        it "redirects to edit course" do
          post :create, :course => @course.attributes
          @new_course = assigns(:course)
          response.should redirect_to(edit_course_path(@new_course))
        end
      end

      describe "with valid params for an existing course number" do

        before(:each) do
          @number = "96-700"
          @course = FactoryGirl.create(:course, :number => @number)
        end

        it "saves a newly created item" do
          lambda {
            post :create, :course => {"number"=>@number, "semester"=>"Summer", "year"=>"2011"}
          }.should change(Course, :count).by(1)
        end

        it "redirects to edit course" do
          post :create, :course => @course.attributes
          @new_course = assigns(:course)
          response.should redirect_to(edit_course_path(@new_course))
        end

      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved item as item" do
          lambda {
            post :create, :course => {}
          }.should_not change(Course, :count)
          assigns(:course).should_not be_nil
          assigns(:course).should be_kind_of(Course)
        end

        it "re-renders the 'new' template" do
          post :create, :course => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => course.to_param, :course => {:name => 'NNNNN'}
        end

        it "updates the requested course name" do
          #error has to do with course model being versioned. Making it un-versioned lets the test pass
          course.reload.name.should == "NNNNN"
        end

        it "should assign @course" do
          assigns(:course).should_not be_nil
        end

        it "redirects to the course" do
          response.should redirect_to(course_path(course))
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => course.to_param, :course => {:name => ''}
        end

        it "should assign @course" do
          assigns(:course).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("configure")
        end
      end

    end

    describe "not DELETE destroy" do
      before do
        delete :destroy, :id => course.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "any admin can" do
#    before do
#      login(FactoryGirl.create(:admin_andy))
#    end

    describe "DELETE destroy" do

      it "destroys the course" do
#       course.should_receive(:destroy)

#        lambda {
#          a = Course.count
#          c = course
#          delete :destroy, :id => course.to_param
#          b = Course.count
#          t = 1
#        }.should change(Course, :count).by(1)
      end

    end

  end
end