require 'spec_helper'

describe SponsoredProjectSponsorsController do


  let(:sponsor) { Factory(:sponsored_project_sponsor) }

  context "as admin do " do

    before do
      @admin_andy = Factory(:admin_andy)
      login(@admin_andy)
    end
    
    describe "GET new sponsor" do
      it 'assigns a new sponsor as @sponsor' do
        get :new
        assigns(:sponsor).should_not be_nil
      end
    end

    describe "GET edit sponsor" do
      before do
        get :edit, :id => sponsor.to_param
      end

      it "assigns sponsor" do
        assigns(:sponsor).should == sponsor
      end
    end

    describe "POST create" do

      describe "with valid params" do
        before(:each) do
          @sponsor = Factory.build(:sponsored_project_sponsor)
        end

        it "saves a newly created sponsor" do
          lambda {
            post :create, :sponsored_project_sponsor => @sponsor.attributes
          }.should change(SponsoredProjectSponsor, :count).by(1)
        end

        it "redirects to the index of projects" do
          post :create, :sponsored_project_sponsor => @sponsor.attributes
          response.should redirect_to(sponsored_projects_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved sponsor as sponsor" do
          lambda {
            post :create, :sponsored_project_sponsor => {}
          }.should_not change(SponsoredProjectSponsor, :count)
          assigns(:sponsor).should_not be_nil
          assigns(:sponsor).should be_kind_of(SponsoredProjectSponsor)
        end

        it "re-renders the 'new' template" do
          post :create, :sponsored_project_sponsor => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => sponsor.to_param, :sponsored_project_sponsor => {:name => 'NNNNN'}
        end

        it "updates the requested sponsor name" do
          sponsor.reload.name.should == "NNNNN"
        end

        it "should assign @sponsor" do
          assigns(:sponsor).should_not be_nil
        end

        it "redirects to projects" do
          response.should redirect_to(sponsored_projects_path)
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => sponsor.to_param, :sponsored_project_sponsor => {:name => ''}
        end

        it "should assign @sponsor" do
          assigns(:sponsor).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end

    end

    describe "GET archive" do
      it "archives the sponsor" do
        get :archive, :id => sponsor.to_param
        flash[:notice].should == "Sponsor was successfully archived."
      end
    end
  end

  context "as faculty do " do

    before do
      @faculty_frank = Factory(:faculty_frank)
      login(@faculty_frank)
    end

    [:new, :edit, :archive].each do |http_verb|
      describe "GET #{http_verb}" do
        it "can't access page" do
          get http_verb, :id => sponsor.to_param
          response.should redirect_to(root_path)
          flash[:error].should == I18n.t(:no_permission)
        end
      end
    end

    describe "POST create" do
      it "can't access page" do
        post :create, :sponsored_project_sponsor => sponsor.attributes
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end

    describe "PUT update" do
      it "can't access page" do
        put :update, :id => sponsor.to_param, :sponsored_project_sponsor => {:name => 'NNNNN'}
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end


  end

end