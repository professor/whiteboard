require 'spec_helper'
require 'controllers/permission_behavior'

describe CoursesController do


  let(:course) { Factory(:course) }

  shared_examples_for "courses_for_a_given_semester" do
    specify { assigns(:courses).should_not be_nil }
    specify { assigns(:semester).should_not be_nil }
    specify { assigns(:semester).should_not be_nil }
    specify { assigns(:all_courses).should == false }
  end

  context "any user can" do
    before do
      UserSession.create(Factory(:student_sam))
    end

    describe "GET current semester" do
      before do
        get :current_semester
      end

      it_should_behave_like "courses_for_a_given_semester"
    end

    describe "GET next semester" do
      before do
        get :next_semester
      end

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

    describe "GET new course" do
      before do
        get :new
      end

      it_should_behave_like "permission denied"
    end


    describe "GET configure course" do
      before do
        get :configure, :id => course.to_param
      end

      it_should_behave_like "permission denied"
    end

    describe "POST create" do
      before do
        @course = Factory.build(:course)
        post :create, :course => @course.attributes
      end

      it_should_behave_like "permission denied"
    end

    describe "PUT update" do
      before do
        put :update, :id => course.to_param, :course => {:name => 'NNNNN'}
      end

      it_should_behave_like "permission denied"
    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => course.to_param
      end

      it_should_behave_like "permission denied"
    end

  end

  context "any staff can" do
    before do
      UserSession.create(Factory(:faculty_frank))
    end

    describe "GET new course" do
      before do
        get :new
      end

      specify { assigns(:course).should_not be_nil }
    end

    describe "GET edit course" do
      before do
        get :edit, :id => course.to_param
      end

      specify { assigns(:course).should == course }
    end

    describe "GET configure course" do
      before do
        get :configure, :id => course.to_param
      end

      specify { assigns(:course).should == course }
    end


    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @course = Factory.build(:course)
        end

        it "saves a newly created course" do
          lambda {
            post :create, :course => @course.attributes
          }.should change(Course, :count).by(1)
        end

        it "redirects to the course" do
          post :create, :course => @course.attributes
          response.should redirect_to(course_path(assigns(:course).id))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved course as course" do
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
          response.should render_template("edit")
        end
      end

    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => course.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "any admin can" do
#    before do
#      UserSession.create(Factory(:admin_andy))
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