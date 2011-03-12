require 'spec_helper'

describe SponsoredProjectEffortsController do



  describe "GET edit as admin" do
    before(:each) do
#      @faculty_frank = Factory(:faculty_frank)
#      @allocation_frank_p1 = Factory(:sponsored_project_allocation, :person => @faculty_frank)
#      @allocation_frank_p2 = Factory(:sponsored_project_allocation, :person => @faculty_frank)
#      @effort_frank_p1 = Factory(:sponsored_project_effort)
#      @effort_frank_p2 = Factory(:sponsored_project_effort)
#
#      effort_frank_p1.allocation.person = faculty_frank
#      effort_frank_p2.allocation.person = faculty_frank
#
#      @admin_andy = Factory(:admin_andy)

      @effort_mock = mock_model(SponsoredProjectEffort)
      SponsoredProjectEffort.stub(:find).and_return([@effort_mock, @effort_mock])
      get :edit
    end

    it 'assigns @efforts' do
      assigns(:efforts).should == [@effort_mock, @effort_mock]
    end
  end

  describe "GET edit as faculty" do
    before(:each) do
      @faculty_frank = Factory(:faculty_frank)
      @faculty_fagan = Factory(:faculty_fagan)

      allocation_frank = stub_model(SponsoredProjectAllocation)
      allocation_frank.stub(:person).and_return(@faculty_frank)

      allocation_fagan = stub_model(SponsoredProjectAllocation)
      allocation_fagan.stub(:person).and_return(@faculty_fagan)

      @effort_mock_frank = mock_model(SponsoredProjectEffort)
      @effort_mock_frank.should_receive(:allocation).and_return(allocation_frank)

      @effort_mock_fagan = mock_model(SponsoredProjectEffort)
      @effort_mock_fagan.should_receive(:allocation).and_return(allocation_fagan)
    end

    it 'assigns @efforts' do
      faculty_frank = Factory(:faculty_frank)
      efforts = [stub_model(SponsoredProjectEffort)]
      SponsoredProjectEffort.should_receive(:current_months_efforts_for_user).with(faculty_frank.id).and_return(efforts)
      get :edit, :name => faculty_frank.twiki_name
      assigns(:efforts).should == efforts
    end
  end
#
#  describe 'POST create' do
#
#    describe "with valid params" do
#      before(:each) do
#        @allocation = Factory.build(:sponsored_project_allocation)
#      end
#
#      it "saves a newly created allocation" do
#        lambda {
#          post :create, :sponsored_project_allocation => @allocation.attributes
#        }.should change(SponsoredProjectAllocation,:count).by(1)
#      end
#
#      it "redirects to the index of allocations" do
#        post :create, :sponsored_project_allocation => @allocation.attributes
#        response.should redirect_to(sponsored_project_allocations_path)
#      end
#    end
#
#    describe "with invalid params" do
#      it "assigns a newly created but unsaved allocation as @allocation" do
#        lambda {
#          post :create, :sponsored_project_allocation => {}
#        }.should_not change(SponsoredProjectAllocation,:count)
#        assigns(:allocation).should_not be_nil
#        assigns(:allocation).should be_kind_of(SponsoredProjectAllocation)
#      end
#
#      it "re-renders the 'new' template" do
#        post :create, :sponsored_project_allocation => {}
#        response.should render_template("new")
#      end
#    end
#  end
#
#  describe "PUT update" do
#
#    describe "with valid params" do
#
#      before do
#        put :update, :id => allocation.to_param, :sponsored_project_allocation => {:current_allocation => 50}
#      end
#
#      it "updates the requested allocation" do
#        allocation.reload.current_allocation.should == 50
#      end
#
#      it "should assign @allocation" do
#        assigns(:allocation).should_not be_nil
#      end
#
#      it "redirects to allocations" do
#        response.should redirect_to(sponsored_project_allocations_path)
#      end
#    end
#
#    describe "with invalid params" do
#      before do
#        put :update, :id => allocation.to_param, :sponsored_project_allocation => {:current_allocation => ''}
#      end
#
#      it "should assign @allocation" do
#        assigns(:allocation).should_not be_nil
#      end
#
#      it "re-renders the 'edit' template" do
#        response.should render_template("edit")
#      end
#    end
#  end


end