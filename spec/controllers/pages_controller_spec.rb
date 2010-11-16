require 'spec_helper'

describe PagesController do
  integrate_views

  describe "SOMETHING ELSE" do
    it "should allow faculty to bundle pages together in an order"
    it "should allow faculty to reorder the items in the bundle"
    it "should allow a bundle to be copied for another course"
  end


  it "allows named pages in the url" do
      { :get => "/pages/ppm" }.should be_routable
       get "/pages/ppm"
#       need to create ppm model in test database    
#       response.code.should == "302"
  end

  it "allows named urls with additional / " do
    { :get => "/pages/ppm/announcements" }.should be_routable
     get "/pages/ppm/announcements"
#       need to create ppm model in test database
#       response.code.should == "302"
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


end

