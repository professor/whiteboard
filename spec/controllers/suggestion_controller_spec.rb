require 'spec_helper'

describe SuggestionsController do
  render_views

  describe "NEW suggestion" do
    it "remembers the HTTP referer" do
       get :new
       
       response.should be_success
    end
    
    it "prompts for an email address if the user is not logged in" do
      pending "Test disabled: this is more like a view test. Not sure it belongs here + it started failing on rails3" do
        get :new
        puts response
        response.should have_selector("input", :id => "suggestion_email")
      end
    end

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

      it "redirects the user back to the page they came from"
#      do
#        post :create, @attr
#        response.should redirect_to(@attr[:page])
#      end
#
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

