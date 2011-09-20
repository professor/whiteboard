require 'spec_helper'

describe PagesController do

  before(:each) do
    Page.any_instance.stub(:update_search_index)
    Page.any_instance.stub(:delete_from_search)
  end

  context "any user can" do
    before do
      Page.delete_all
      login(Factory(:student_sam))
      @page = Factory(:page)
    end

    shared_examples_for "finding page" do
      it "assigns page" do
        assigns(:page).should == @page
      end
    end

    describe "GET index" do
      it "assigns all pages as @pages" do
        get :index
        assigns(:pages).should_not be_nil
      end
    end

    describe "GET show" do
      before do
        get :show, :id => @page.to_param
      end
      it_should_behave_like "finding page"
    end

    describe "GET new" do
      it "assigns a new page as page" do
        get :new
        assigns(:page).should_not be_nil
      end
    end

    describe "GET edit" do
      before do
        get :edit, :id => @page.to_param
      end
      it_should_behave_like "finding page"
    end
  end

  context "as a student can" do
    before do
      Page.delete_all
      login(Factory(:student_sam))
      @page = Factory(:page, :title => "new title")
    end

    describe "GET edit" do
      it "but not for a page that is editable only by faculty" do
      @page.is_editable_by_all = false
      get :edit, :id => @page.to_param
      response.should redirect_to(page_url)
       end
    end

   describe "POST update" do
      it "but not for a page that is editable only by faculty" do
      @page.is_editable_by_all = false
      @page.save
      post :update, :page => @page.attributes, :id => @page.to_param
      response.should redirect_to(page_url)
      flash[:error].should == "You don't have permission to do this action."
      end

      it "will update updated_by_user_id"
    end

  end

  context "as a faculty member can" do

    before do
      login(Factory(:faculty_frank))

      @page = Factory(:page)
    end

    describe "GET edit" do
      context "for a page that is not editable by all" do
        before do
          @page.is_editable_by_all = false
          get :edit, :id => @page.to_param
        end
        it_should_behave_like "finding page"
      end

    end
  end






















  
#  it "allows named pages in the url" do
#     @ppm = Factory(:ppm)
#       { :get => "/pages/#{@ppm.url}" }.should be_routable
#       get "/pages/#{@ppm.url}"
#       response.code.should == "302"
#  end

#  it "allows named urls with additional / " do
#    { :get => "/pages/ppm/announcements" }.should be_routable
#     get "/pages/ppm/announcements"
##       need to create ppm model in test database
##       response.code.should == "302"
#  end


#  describe "SHOW page" do
#    context "all pages" do
#      it "should allow anyone to add comments to the page"
#    end
#
#    context "three tab page" do
#      it "should show three tabs"
#      it "should show all the tasks in the course"
#    end
#
#    context "normal page" do
#      it ""
#    end
#
#  end
#
#
#  describe "SOMETHING ELSE" do
#    it "should allow faculty to bundle pages together in an order"
#    it "should allow faculty to reorder the items in the bundle"
#    it "should allow a bundle to be copied for another course"
#  end
#
#  describe "NEW page" do
#    it "should allow faculty to upload attachments"
#    it "should allow faculty to choose between normal page or three tabs"
#  end
#
#
#  describe "EDIT page" do
#    it "should do everything that NEW page does"
#    it "should allow faculty to replace an attachment"
#    it "should saves previous versions of the page"
#    it "should allow faculty to comment about the changes"
#    it "should allow three tab page to be converted to normal page without loosing three tab content"
#    it "should allow normal page to be converted to three tab page with contents ending in tab one"
#
#  end


end

