require 'spec_helper'
require 'controllers/permission_behavior'

describe CurriculumCommentTypesController do


  let(:curriculum_comment_type) { Factory(:curriculum_comment_type) }


  context "any user can" do
    before do
      login(Factory(:student_sam))
      @redirect_url = curriculum_comment_types_url
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:curriculum_comment_types).should_not be_nil }
    end


    describe "GET show" do
      before do
        get :show, :id => curriculum_comment_type.to_param
      end

      specify { assigns(:curriculum_comment_type).should_not be_nil }
    end

    describe "GET new" do
      before do
        get :new
      end

      it_should_behave_like "permission denied"
    end

    describe "POST create" do
      before do
        @curriculum_comment_type = Factory.build(:curriculum_comment_type)
        post :create, :curriculum_comment_type => @curriculum_comment_type.attributes
      end

      it_should_behave_like "permission denied"
    end

    describe "PUT update" do
      before do
        put :update, :id => curriculum_comment_type.to_param, :curriculum_comment_type => {:name => 'NNNNN'}
      end

      it_should_behave_like "permission denied"
    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => curriculum_comment_type.to_param
      end

      it_should_behave_like "permission denied"
    end

  end

  context "any staff can" do
    before do
      login(Factory(:faculty_frank))
      @redirect_url = curriculum_comment_types_url
    end

    describe "GET new " do
      before do
        get :new
      end

      specify { assigns(:curriculum_comment_type).should_not be_nil }
    end

    describe "GET edit" do
      before do
        get :edit, :id => curriculum_comment_type.to_param
      end

      specify { assigns(:curriculum_comment_type).should == curriculum_comment_type }
    end


    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @curriculum_comment_type = Factory.build(:curriculum_comment_type)
        end

        it "saves a newly created" do
          lambda {
            post :create, :curriculum_comment_type => @curriculum_comment_type.attributes
          }.should change(CurriculumCommentType, :count).by(1)
        end

        it "redirects to the item" do
          post :create, :curriculum_comment_type => @curriculum_comment_type.attributes
          response.should redirect_to(curriculum_comment_type_path(assigns(:curriculum_comment_type).id))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved item as item" do
          lambda {
            post :create, :curriculum_comment_type => {}
          }.should_not change(CurriculumCommentType, :count)
          assigns(:curriculum_comment_type).should_not be_nil
          assigns(:curriculum_comment_type).should be_kind_of(CurriculumCommentType)
        end

        it "re-renders the 'new' template" do
          post :create, :curriculum_comment_type => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => curriculum_comment_type.to_param, :curriculum_comment_type => {:name => 'NNNNN'}
        end

        it "updates the requested curriculum_comment_type name" do
          curriculum_comment_type.reload.name.should == "NNNNN"
        end

        it "should assign @curriculum_comment_type" do
          assigns(:curriculum_comment_type).should_not be_nil
        end

        it "redirects to the curriculum_comment_type" do
          response.should redirect_to(curriculum_comment_type_path(curriculum_comment_type))
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => curriculum_comment_type.to_param, :curriculum_comment_type => {:name => ''}
        end

        it "should assign @curriculum_comment_type" do
          assigns(:curriculum_comment_type).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end

    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => curriculum_comment_type.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "any admin can" do
#    before do
#      login(Factory(:admin_andy))
#    end

    describe "DELETE destroy" do

      it "destroys the curriculum_comment_type" do
#       curriculum_comment_type.should_receive(:destroy)

#        lambda {
#          a = Course.count
#          c = curriculum_comment_type
#          delete :destroy, :id => curriculum_comment_type.to_param
#          b = Course.count
#          t = 1
#        }.should change(CurriculumCommentType, :count).by(1)
      end

    end

  end
end