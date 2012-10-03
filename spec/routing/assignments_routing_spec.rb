require "spec_helper"

describe AssignmentsController do
  describe "routing" do

    it "routes to #index" do
      get("/assignments").should route_to("assignments#index")
    end

    it "routes to #new" do
      get("/assignments/new").should route_to("assignments#new")
    end

    it "routes to #show" do
      get("/assignments/1").should route_to("assignments#show", :id => "1")
    end

    it "routes to #edit" do
      get("/assignments/1/edit").should route_to("assignments#edit", :id => "1")
    end

    it "routes to #create" do
      post("/assignments").should route_to("assignments#create")
    end

    it "routes to #update" do
      put("/assignments/1").should route_to("assignments#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/assignments/1").should route_to("assignments#destroy", :id => "1")
    end

  end
end
