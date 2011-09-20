require 'spec_helper'

describe SponsoredProjectAllocationsController do

  let(:allocation) { Factory(:sponsored_project_allocation) }

  context "as admin do" do

    before do
      @admin_andy = Factory(:admin_andy)
      login(@admin_andy)
    end

    describe 'GET index' do

      it 'assigns @allocations' do
        get :index
        assigns(:allocations).should_not be_nil
      end
    end

    describe 'GET new' do

      it 'assigns @allocation' do
        get :new
        assigns(:allocation).should_not be_nil
      end

      it 'assigns @projects' do
        get :new
        assigns(:projects).should_not be_nil
      end

      it 'assigns @people' do
        get :new
        assigns(:people).should_not be_nil
      end

    end

    describe "GET edit" do
      before(:each) do
        get :edit, :id => allocation.to_param
      end

      it 'assigns @allocation' do
        assigns(:allocation).should == allocation
      end

      it 'assigns @projects' do
        assigns(:projects).should_not be_nil
      end

      it 'assigns @people' do
        assigns(:people).should_not be_nil
      end
    end

    describe 'POST create' do

      describe "with valid params" do
        before(:each) do
          @allocation = Factory.build(:sponsored_project_allocation)
        end

        it "saves a newly created allocation" do
          lambda {
            post :create, :sponsored_project_allocation => @allocation.attributes
          }.should change(SponsoredProjectAllocation,:count).by(1)
        end

        it "redirects to the index of allocations" do
          post :create, :sponsored_project_allocation => @allocation.attributes
          response.should redirect_to(sponsored_project_allocations_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved allocation as @allocation" do
          lambda {
            post :create, :sponsored_project_allocation => {}
          }.should_not change(SponsoredProjectAllocation,:count)
          assigns(:allocation).should_not be_nil
          assigns(:allocation).should be_kind_of(SponsoredProjectAllocation)
        end

        it "re-renders the 'new' template" do
          post :create, :sponsored_project_allocation => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do

      describe "with valid params" do

        before do
          put :update, :id => allocation.to_param, :sponsored_project_allocation => {:current_allocation => 50}
        end

        it "updates the requested allocation" do
          allocation.reload.current_allocation.should == 50
        end

        it "should assign @allocation" do
          assigns(:allocation).should_not be_nil
        end

        it "redirects to allocations" do
          response.should redirect_to(sponsored_project_allocations_path)
        end
      end

      describe "with invalid params" do
        before do
          put :update, :id => allocation.to_param, :sponsored_project_allocation => {:current_allocation => ''}
        end

        it "should assign @allocation" do
          assigns(:allocation).should_not be_nil
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end

     describe "GET archive" do
      it "archives the allocation" do
        get :archive, :id => allocation.to_param
        flash[:notice].should == "Allocation was successfully archived."
      end
    end
  end

  context "as faculty do " do

    before do
      @faculty_frank = allocation.person
      @faculty_frank.is_admin = false
      login(@faculty_frank)
    end

    [:index, :new, :edit, :archive].each do |http_verb|
      describe "GET #{http_verb}" do
        it "can't access page" do
          get http_verb, :id => allocation.to_param
          response.should redirect_to(root_path)
          flash[:error].should == I18n.t(:no_permission)
        end
      end
    end

    describe "POST create" do
      it "can't access page" do
        post :create, :sponsored_project_allocation => allocation.attributes
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end

    describe "PUT update" do
      it "can't access page" do
        put :update, :id => allocation.to_param, :sponsored_project_allocation => {:current_allocation => 50}
        response.should redirect_to(root_path)
        flash[:error].should == I18n.t(:no_permission)
      end
    end
  end
end