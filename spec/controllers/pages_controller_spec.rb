require 'spec_helper'

describe PagesController do
  integrate_views

  describe "SOMETHING ELSE" do
    it "should allow faculty to bundle pages together in an order"
    it "should allow faculty to reorder the items in the bundle"
    it "should allow a bundle to be copied for another course"
  end


  describe "SHOW page" do
    context "all pages" do
#moved to model      it "should allow faculty to edit it" 
#moved to model      it "should allow faculty to see previous versions of the page"
      it "should allow anyone to add comments to the page"
#moved to model      it "should show who did the last edit and when it occurred"
    end

    context "three tab page" do
      it "should show three tabs"
      it "should show all the tasks in the course"
    end

    context "normal page" do
      it ""
    end

  end


  describe "NEW page" do
    it "should allow faculty to upload attachments"
    it "should allow faculty to choose between normal page or three tabs"
  end


  describe "EDIT page" do
    it "should do everything that NEW page does"
    it "should allow faculty to replace an attachment"
    it "should saves previous versions of the page"
    it "should allow faculty to comment about the changes"
    it "should allow three tab page to be converted to normal page without loosing three tab content"
    it "should allow normal page to be converted to three tab page with contents ending in tab one"

  end


  describe "POST suggestion" do

    describe "success" do

# Michael Hartl's way
#      before(:each) do
#        @attr = { :comment => "This is a suggestion", :page => "http://rails.sv.cmu.edu",
#        :email => "" }
#        @suggestion = Factory(:suggestion, @attr)
#        Suggestion.stub!(:new).and_return(@suggestion)
#        @suggestion.should_receive(:save).and_return(true)
#      end


#Rspec books way
# Repsec start
      let (:suggestion) { mock_model(Suggestion).as_null_object }

      before do
        @attr = { :comment => "This is a suggestion", :page => "http://rails.sv.cmu.edu",
                  :email => "" }        
        Suggestion.stub(:new).and_return(suggestion)
        Suggestion.stub(:save).and_return(suggestion)
      end
      

      it "creates a new suggestion" do
#        Suggestion.should_receive(:new).with_options("page" => @attr[:page]).and_return(suggestion)
        post :create, :suggestion => @attr 
      end
#rspec book end

      it "remembers the user id if the user is logged in"

      it "emails Todd that a suggestion has been created"

      it "sets a flash[:notice] message" do
        post :create
        flash[:notice].should == "Thank you for your suggestion"
      end

      it "redirects the user back to the page they came from" do
        post :create, @attr
        response.should redirect_to(@attr[:page])
      end

    end

  end


#  describe "Create a suggestion" do
#    it "should work when the user is not logged in" do
#      get 'new'
#      response.should be_success
#
#    end
#
#    it "should work when the user is logged in "
#
#    it "should remember the url of the page the suggestion was made on"
#
#    it "should email Todd that a suggestion was created"
#  end
#
#  describe "GET 'index'" do
#    it "should be successful" do
#      get 'index'
#      response.should be_success
#    end
#  end

end

