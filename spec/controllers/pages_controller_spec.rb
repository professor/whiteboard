require 'spec_helper'

describe PagesController do
  shared_examples_for "finding page" do
  before(:each) do
    Page.any_instance.stub(:update_search_index)
    Page.any_instance.stub(:delete_from_search)
  end

  context "any user can" do
    before do
      Page.delete_all
      login(FactoryGirl.create(:student_sam))
      @page = FactoryGirl.create(:page)
    end


      it "assigns page" do
        assigns(:page).should == @page
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

    describe "when requesting a page that does not exist" do
      before do
        @nonexistent_page_id = "some_page"
        get :show, :id => @nonexistent_page_id
      end

      it "should redirect to GET new" do
        response.should redirect_to(:controller => :pages, :action => :new, :url => @nonexistent_page_id)
      end

      it "should prepopulate the requested name" do
        get :new, :url => @nonexistent_page_id
        assigns(:page).url.should == @nonexistent_page_id
      end

      it "should display a helpful message" do
        flash[:error].should == "Page with an id of #{@nonexistent_page_id} is not in this system. You may create it using the form below."
      end
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
    describe "GET show with non-exist page" do
      it "redirects to the pages index" do
        @page_name = 'some_new_page_i_made_up'
        @stylized_page_name = 'Some New Page I Made Up'
        get :show, :id => @page_name
        response.code.should == "302"
        response.should redirect_to(new_page_url(:url => @page_name))
        flash[:error].should == "Page with an id of #{@page_name} is not in this system. You may create it using the form below."
      end

      it "new should handle the title GET parameter and assign it to page title and page url" do
        @page_name = 'some_new_page_i_made_up'
        @stylized_page_name = 'Some New Page I Made Up'
        get :new, :url => @page_name
        response.code.should == "200"
        assigns(:page).title.should == @stylized_page_name
        assigns(:page).url.should == @page_name
      end

      it "should handle titles with no underscores" do
        @page_name = "hello"
        @stylized_page_name = "Hello"
        get :new, :url => @page_name
        response.code.should == "200"
        assigns(:page).title.should == @stylized_page_name
        assigns(:page).url.should == @page_name
      end

      it "should handle title with non-alphabetic characters after an underscore" do
        @page_name = "page_name_%goes_$here"
        @stylized_page_name = "Page Name %goes $here"
        get :new, :url => @page_name
        response.code.should == "200"
        assigns(:page).title.should == @stylized_page_name
        assigns(:page).url.should == @page_name
      end

      it "should truncate underscores that are at the end of the title" do
        @page_name = "page_name_with_trailing_underscore_"
        @stylized_page_name = "Page Name With Trailing Underscore"
        get :new, :url => @page_name
        response.code.should == "200"
        assigns(:page).title.should == @stylized_page_name
        assigns(:page).url.should == @page_name
      end
    end
  end

  context "as a student can" do
    before do
      Page.delete_all
      login(FactoryGirl.create(:student_sam))
      @page = FactoryGirl.create(:page, :title => "new title", :viewable_by => "staff", :is_editable_by_all => false)
    end

    describe "GET show" do
      it "but not for a page that is viewable only by faculty" do
        get :show, :id => @page.to_param
        response.should redirect_to(root_url)
      end
    end

    describe "GET edit" do
      it "but not for a page that is editable only by faculty" do
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

    describe "POST revert" do
      it "a page that is editable by all" do
        @page.update_attributes :viewable_by => "users", :is_editable_by_all => true
        post :revert, :id => @page.to_param, :version => 1
        current_version = @page.versions.find_by_number 3
        current_version.reverted_from.should == 1
        response.should redirect_to(page_url)
      end

      it "but not for a page that is editable only by faculty" do
        post :revert, :id => @page.to_param, :version => 1
        response.should redirect_to(page_url)
      end
    end
  end

  context "as a faculty member can" do
    before do
      login(FactoryGirl.create(:faculty_frank))

      @page = FactoryGirl.create(:page, :title => "new title", :viewable_by => "staff", :is_editable_by_all => false)
    end

    describe "GET show" do
      context "for a page that is not vieweable by all" do
        before do
          get :show, :id => @page.to_param
        end
        it_should_behave_like "finding page"
      end
    end

    describe "GET edit" do
      context "for a page that is not editable by all" do
        before do
          get :edit, :id => @page.to_param
        end
        it_should_behave_like "finding page"

        it "should show a notice when someone else is editing the page" do
          sign_out @current_user
          login(FactoryGirl.create(:faculty_fagan))
          get :edit, :id => @page.to_param
          flash[:notice].should include("Faculty Frank")
        end

        it "shouldn't show a notice when someone has been editing the page for more than 30 minutes" do
          sign_out @current_user
          login(FactoryGirl.create(:faculty_fagan))
          @page.current_edit_started_at = 30.minutes.ago
          @page.save
          get :edit, :id => @page.to_param
          flash[:notice].should be_nil
        end

        it "shouldn't show a notice when someone has finished editing a page" do
          post :update, :page => @page.attributes, :id => @page.to_param
          sign_out @current_user
          login(FactoryGirl.create(:faculty_fagan))
          get :edit, :id => @page.to_param
          flash[:notice].should_not include("editing")
        end

        it "shouldn't show a notice when the same person is editing the page" do
          get :edit, :id => @page.to_param
          flash[:notice].should be_nil
        end
      end
    end

    describe "POST revert" do
      it "a page that is editable by faculty" do
        @page.update_attribute :title, "the title for next version"
        post :revert, :id => @page.to_param, :version => 1
        current_version = @page.versions.find_by_number 3
        current_version.reverted_from.should == 1
        response.should redirect_to(page_url)
      end
    end
  end


#  it "allows named pages in the url" do
#     @ppm = FactoryGirl.create(:ppm)
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
end

