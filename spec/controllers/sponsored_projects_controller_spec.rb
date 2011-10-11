require 'spec_helper'

describe SponsoredProjectsController do

  let(:project) { Factory(:sponsored_project) }  # This is similar to setting an @project in a before block
                                                 # let(:project) makes a user method available

  context "as admin do " do

    before do
      @admin_andy = Factory(:admin_andy)
      login(@admin_andy)
    end

    describe "GET index" do
      it "assigns all projects as @projects" do
        get :index
        assigns(:projects).should_not be_nil
      end

      it "assigns all sponsors as @sponsors" do
        get :index
        assigns(:sponsors).should_not be_nil
      end
    end

    describe "GET new" do
      it "assigns a new sponsored project as project" do
        get :new
        assigns(:project).should_not be_nil
      end
    end

   describe "GET edit" do
      before do
        get :edit, :id => project.to_param
      end

      it "assigns project" do
        assigns(:project).should == project
      end

    end

    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @project = Factory.build(:sponsored_project)
        end

        it "saves a newly created project" do
          lambda {
            post :create, :sponsored_project => @project.attributes
          }.should change(SponsoredProject,:count).by(1)
        end

        it "redirects to the index of projects" do
          post :create, :sponsored_project => @project.attributes
          response.should redirect_to(sponsored_projects_path)
        end

        it "assigns all sponsors as @sponsors" do
          post :create, :sponsored_project => @project.attributes
          assigns(:sponsors).should_not be_nil
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved project as project" do
          lambda {
            post :create, :sponsored_project => {}
          }.should_not change(SponsoredProject,:count)
          assigns(:project).should_not be_nil
          assigns(:project).should be_kind_of(SponsoredProject)
        end

        it "re-renders the 'new' template" do
          post :create, :sponsored_project => {}
          response.should render_template("new")
        end

        it "assigns all sponsors as @sponsors" do
          post :create, :sponsored_project => {}
          assigns(:sponsors).should_not be_nil
        end
      end
    end


    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => project.to_param, :sponsored_project => {:name => 'NNNNN'}
        end

        it "updates the requested project name" do
          project.reload.name.should == "NNNNN"
        end

        it "should assign @project" do
          assigns(:project).should_not be_nil
        end

        it "redirects to projects" do
          response.should redirect_to(sponsored_projects_path)
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => project.to_param, :sponsored_project => {:name => ''}
        end

        it "should assign @project" do
          assigns(:project).should_not be_nil
        end

        it "assigns all sponsors as @sponsors" do
          assigns(:sponsors).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end

    end

    describe "GET archive" do
      it "archives the project" do
        get :archive, :id => project.to_param
        flash[:notice].should == "Project was successfully archived."
      end
    end
  end

  context "as faculty do " do

    before do
      @faculty_frank = Factory(:faculty_frank)
      login(@faculty_frank)
    end

    [:index, :new, :edit, :archive].each do |http_verb|
      describe "GET #{http_verb}" do
        it "can't access page" do
          get http_verb, :id => project.to_param
          response.should redirect_to(root_path)
          flash[:error].should == I18n.t(:no_permission)
        end
      end
    end

    describe "POST create" do
      it "can't access page" do
        post :create, :sponsored_project => project.attributes
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end

    describe "PUT update" do
      it "can't access page" do
        put :update, :id => project.to_param, :sponsored_project => {:name => 'NNNNN'}
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end


  end

end