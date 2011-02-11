require 'spec_helper'

describe SponsoredProjectsController do

  let(:project) { Factory(:sponsored_project) }  # This is similar to setting an @project in a before block
                                                 # let(:project) makes a user method available

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

#
#    it 'assigns a new name' do
#      get :new
#      assigns(:project).name.should_not be_empty
#    end
#
#    it 'assigns a sponsor' do
#      get :new
#      assigns(:project).sponsor.name.should_not be_empty
#    end


#  describe "GET new sponsor" do
#    it '' do
#      get :new_sponsor
#    end
#  end


end