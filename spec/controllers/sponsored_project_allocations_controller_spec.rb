require 'spec_helper'

describe SponsoredProjectAllocationsController do

  let(:allocation) { Factory(:sponsored_project_allocation) }

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

  describe 'POST update' do

  end
end