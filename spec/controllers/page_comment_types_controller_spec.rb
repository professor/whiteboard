require 'spec_helper'
require 'controllers/permission_behavior'

describe PageCommentTypesController do

  let(:page_comment_type) { FactoryGirl.create(:page_comment_type) }

  context "any user can" do
    before do
      login(FactoryGirl.create(:student_sam))
      @redirect_url = page_comment_types_url
    end

    describe "GET index" do
      before do
        get :index
      end

      specify { assigns(:page_comment_types).should_not be_nil }
    end


    describe "GET show" do
      before do
        get :show, :id => page_comment_type.to_param
      end

      specify { assigns(:page_comment_type).should_not be_nil }
    end

    describe "GET new" do
      before do
        get :new
      end

      it_should_behave_like "permission denied"
    end

    describe "POST create" do
      before do
        @page_comment_type = FactoryGirl.build(:page_comment_type)
        post :create, :page_comment_type => @page_comment_type.attributes
      end

      it_should_behave_like "permission denied"
    end

    describe "PUT update" do
      before do
        put :update, :id => page_comment_type.to_param, :page_comment_type => {:name => 'NNNNN'}
      end

      it_should_behave_like "permission denied"
    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => page_comment_type.to_param
      end

      it_should_behave_like "permission denied"
    end

  end

  context "any staff can" do
    before do
      login(FactoryGirl.create(:faculty_frank))
      @redirect_url = page_comment_types_url
    end

    describe "GET new " do
      before do
        get :new
      end

      specify { assigns(:page_comment_type).should_not be_nil }
    end

    describe "GET edit" do
      before do
        get :edit, :id => page_comment_type.to_param
      end

      specify { assigns(:page_comment_type).should == page_comment_type }
    end


    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @page_comment_type = FactoryGirl.build(:page_comment_type)
        end

        it "saves a newly created" do
          lambda {
            post :create, :page_comment_type => @page_comment_type.attributes
          }.should change(PageCommentType, :count).by(1)
        end

        it "redirects to the item" do
          post :create, :page_comment_type => @page_comment_type.attributes
          response.should redirect_to(page_comment_type_path(assigns(:page_comment_type).id))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved item as item" do
          lambda {
            post :create, :page_comment_type => {}
          }.should_not change(PageCommentType, :count)
          assigns(:page_comment_type).should_not be_nil
          assigns(:page_comment_type).should be_kind_of(PageCommentType)
        end

        it "re-renders the 'new' template" do
          post :create, :page_comment_type => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => page_comment_type.to_param, :page_comment_type => {:name => 'NNNNN'}
        end

        it "updates the requested page_comment_type name" do
          page_comment_type.reload.name.should == "NNNNN"
        end

        it "should assign @page_comment_type" do
          assigns(:page_comment_type).should_not be_nil
        end

        it "redirects to the page_comment_type" do
          response.should redirect_to(page_comment_type_path(page_comment_type))
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => page_comment_type.to_param, :page_comment_type => {:name => ''}
        end

        it "should assign @page_comment_type" do
          assigns(:page_comment_type).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end

    end

    describe "DELETE destroy" do
      before do
        delete :destroy, :id => page_comment_type.to_param
      end

      it_should_behave_like "permission denied"
    end
  end


  context "any admin can" do
#    before do
#      login(FactoryGirl.create(:admin_andy))
#    end

    describe "DELETE destroy" do

      it "destroys the page_comment_type" do
#       page_comment_type.should_receive(:destroy)

#        lambda {
#          a = Course.count
#          c = page_comment_type
#          delete :destroy, :id => page_comment_type.to_param
#          b = Course.count
#          t = 1
#        }.should change(PageCommentType, :count).by(1)
      end

    end

  end
end