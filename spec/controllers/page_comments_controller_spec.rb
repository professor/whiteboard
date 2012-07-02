#require 'spec_helper'
#require 'controllers/permission_behavior'
#
#describe PageCommentsController do
#
#
#  let(:page_comment) { FactoryGirl.create(:page_comment) }
#
#
#  context "any user can" do
#    before do
#      login(FactoryGirl.create(:student_sam))
#    end
#
#    describe "GET index" do
#      before do
#        get :index
#      end
#
#      specify { assigns(:page_comments).should_not be_nil }
#    end
#
#
#    describe "GET show" do
#      before do
#        get :show, :id => page_comment.to_param
#      end
#
#      specify { assigns(:page_comment).should_not be_nil }
#    end
#
#    describe "GET new " do
#      before do
#        get :new
#      end
#
#      specify { assigns(:page_comment).should_not be_nil }
#      specify { assigns(:types).should_not be_nil }
#    end
#
#    describe "GET edit" do
#      before do
#        get :edit, :id => page_comment.to_param
#      end
#
#      specify { assigns(:page_comment).should == page_comment }
#      specify { assigns(:types).should_not be_nil }
#    end
#
#    describe "POST create" do
#
#      describe "with valid params" do
#        before(:each) do
#          @page_comment = FactoryGirl.build(:page_comment)
#        end
#
#        it "saves a newly created" do
#          lambda {
#            post :create, :page_comment => @page_comment.attributes
#          }.should change(PageComment, :count).by(1)
#        end
#
#        it "redirects to the item" do
#          post :create, :page_comment => @page_comment.attributes
#        end
#
#        it "emails the comment" do
#          mailer = double("mailer")
#          mailer.stub(:deliver)
#          PageCommentMailer.should_receive(:comment_update).and_return(mailer)
#          post :create, :page_comment => @page_comment.attributes
#        end
#      end
#
#      describe "with invalid params" do
#        it "assigns a newly created but unsaved item as item" do
#          lambda {
#            post :create, :page_comment => {}
#          }.should_not change(PageComment, :count)
#          assigns(:page_comment).should_not be_nil
#          assigns(:page_comment).should be_kind_of(PageComment)
#        end
#
#        it "re-renders the 'new' template" do
#          post :create, :page_comment => {}
#          response.should render_template("new")
#        end
#      end
#    end
#
#    describe "PUT update" do
#      before do
#        put :update, :id => page_comment.to_param, :page_comment => {:comment => 'NNNNN'}
#      end
#
#      it_should_behave_like "permission denied"
#    end
#
#    describe "DELETE destroy" do
#      before do
#        delete :destroy, :id => page_comment.to_param
#      end
#
#      it_should_behave_like "permission denied"
#    end
#  end
#
#
#  context "the author can" do
#    before do
#      login(FactoryGirl.create(:faculty_frank))
#    end
#
#
#    describe "PUT update" do
#
#      describe "with valid params" do
#
#        before do
#          put :update, :id => page_comment.to_param, :page_comment => {:comment => 'NNNNN'}
#        end
#
##        it "updates the requested page_comment comment" do
##          page_comment.reload.comment.should == "NNNNN"
##        end
#
#        it "should assign @page_comment" do
#          assigns(:page_comment).should_not be_nil
#        end
#
#      end
#
#      describe "with invalid params" do
#        before do
#          put :update, :id => page_comment.to_param, :page_comment => {:comment => ''}
#        end
#
#        it "should assign @page_comment" do
#          assigns(:page_comment).should_not be_nil
#        end
#
##        it "re-renders the 'edit' template" do
##          response.should render_template("edit")
##        end
#      end
#
#    end
#
#    describe "DELETE destroy" do
#      before do
#        delete :destroy, :id => page_comment.to_param
#      end
#
#      it_should_behave_like "permission denied"
#    end
#  end
#
#
#  context "any admin can" do
##    before do
##      login(FactoryGirl.create(:admin_andy))
##    end
#
#    describe "DELETE destroy" do
#
#      it "destroys the page_comment" do
##       page_comment.should_receive(:destroy)
#
##        lambda {
##          a = Course.count
##          c = page_comment
##          delete :destroy, :id => page_comment.to_param
##          b = Course.count
##          t = 1
##        }.should change(PageComment, :count).by(1)
#      end
#
#    end
#
#  end
#end