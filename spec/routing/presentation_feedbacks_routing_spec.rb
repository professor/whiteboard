require "spec_helper"

describe PresentationFeedbacksController do
  describe "routing" do

    it "routes to #index" do
      get("/presentation_feedbacks").should route_to("presentation_feedbacks#index")
    end

    it "routes to #new" do
      get("/presentation_feedbacks/new").should route_to("presentation_feedbacks#new")
    end

    it "routes to #show" do
      get("/presentation_feedbacks/1").should route_to("presentation_feedbacks#show", :id => "1")
    end

    it "routes to #edit" do
      get("/presentation_feedbacks/1/edit").should route_to("presentation_feedbacks#edit", :id => "1")
    end

    it "routes to #create" do
      post("/presentation_feedbacks").should route_to("presentation_feedbacks#create")
    end

    it "routes to #update" do
      put("/presentation_feedbacks/1").should route_to("presentation_feedbacks#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/presentation_feedbacks/1").should route_to("presentation_feedbacks#destroy", :id => "1")
    end

  end
end
