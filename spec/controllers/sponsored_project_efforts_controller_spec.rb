require 'spec_helper'

describe SponsoredProjectEffortsController do

  context "as faculty do" do

    before do
      @faculty_frank = Factory(:faculty_frank)
      UserSession.create(@faculty_frank)
    end

    describe "GET index" do
      before(:each) do
        @effort_mock = mock_model(SponsoredProjectEffort)
        SponsoredProjectEffort.stub(:find).and_return([@effort_mock, @effort_mock])
        get :index
      end

      it 'assigns @efforts' do
        assigns(:efforts).should == [@effort_mock, @effort_mock]
      end
    end

    describe "GET edit" do

      it 'assigns @efforts' do
        efforts = [stub_model(SponsoredProjectEffort)]
        SponsoredProjectEffort.should_receive(:current_months_efforts_for_user).with(@faculty_frank.id).and_return(efforts)
        get :edit, :id => @faculty_frank.twiki_name
        assigns(:efforts).should == efforts
      end
    end

  end


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