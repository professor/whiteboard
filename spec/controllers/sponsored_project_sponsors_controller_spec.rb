require 'spec_helper'

describe SponsoredProjectSponsorsController do


  let(:sponsor) { Factory(:sponsored_project_sponsor) }


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


end