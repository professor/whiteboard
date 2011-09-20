require 'spec_helper'
require 'controllers/permission_behavior'

describe CurriculumCommentsController do


  let(:curriculum_comment) { Factory(:curriculum_comment) }


  context "any user can" do
    before do
      login(Factory(:student_sam))
      @redirect_url = curriculum_comment.url
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:curriculum_comments).should_not be_nil }
    end


    describe "GET show" do
      before do
        get :show, :id => curriculum_comment.to_param
      end

      specify { assigns(:curriculum_comment).should_not be_nil }
    end

    describe "GET new " do
      before do
        get :new
      end

      specify { assigns(:curriculum_comment).should_not be_nil }
      specify { assigns(:types).should_not be_nil }
    end

    describe "GET edit" do
      before do
        get :edit, :id => curriculum_comment.to_param
      end

      specify { assigns(:curriculum_comment).should == curriculum_comment }
      specify { assigns(:types).should_not be_nil }      
    end

    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @curriculum_comment = Factory.build(:curriculum_comment)
        end

        it "saves a newly created" do
          lambda {
            post :create, :curriculum_comment => @curriculum_comment.attributes
          }.should change(CurriculumComment, :count).by(1)
        end

        it "redirects to the item" do
          post :create, :curriculum_comment => @curriculum_comment.attributes
          response.should redirect_to(curriculum_comment.url)
        end

        it "emails the comment" do
          mailer = double("mailer")
          mailer.stub(:deliver)
          CurriculumCommentMailer.should_receive(:comment_update).and_return(mailer)
          post :create, :curriculum_comment => @curriculum_comment.attributes
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved item as item" do
          lambda {
            post :create, :curriculum_comment => {}
          }.should_not change(CurriculumComment, :count)
          assigns(:curriculum_comment).should_not be_nil
          assigns(:curriculum_comment).should be_kind_of(CurriculumComment)
        end

        it "re-renders the 'new' template" do
          post :create, :curriculum_comment => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      before do
        put :update, :id => curriculum_comment.to_param, :curriculum_comment => {:comment => 'NNNNN'}
      end

      it_should_behave_like "not editable"
    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => curriculum_comment.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "the author can" do
    before do
      login(Factory(:faculty_frank))
      @redirect_url = curriculum_comment.url
    end


    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => curriculum_comment.to_param, :curriculum_comment => {:comment => 'NNNNN'}
        end

#        it "updates the requested curriculum_comment comment" do
#          curriculum_comment.reload.comment.should == "NNNNN"
#        end

        it "should assign @curriculum_comment" do
          assigns(:curriculum_comment).should_not be_nil
        end

        it "redirects to the curriculum_comment" do
          response.should redirect_to(curriculum_comment.url)
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => curriculum_comment.to_param, :curriculum_comment => {:comment => ''}
        end

        it "should assign @curriculum_comment" do
          assigns(:curriculum_comment).should_not be_nil
        end

#        it "re-renders the 'edit' template" do
#          response.should render_template("edit")
#        end
      end

    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => curriculum_comment.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "any admin can" do
#    before do
#      login(Factory(:admin_andy))
#    end

    describe "DELETE destroy" do

      it "destroys the curriculum_comment" do
#       curriculum_comment.should_receive(:destroy)

#        lambda {
#          a = Course.count
#          c = curriculum_comment
#          delete :destroy, :id => curriculum_comment.to_param
#          b = Course.count
#          t = 1
#        }.should change(CurriculumComment, :count).by(1)
      end

    end

  end
end