require "spec_helper"

describe NlpsController do
  describe "routing" do

    it "routes to #index" do
      get("/nlps").should route_to("nlps#index")
    end

    it "routes to #new" do
      get("/nlps/new").should route_to("nlps#new")
    end

    it "routes to #show" do
      get("/nlps/1").should route_to("nlps#show", :id => "1")
    end

    it "routes to #edit" do
      get("/nlps/1/edit").should route_to("nlps#edit", :id => "1")
    end

    it "routes to #create" do
      post("/nlps").should route_to("nlps#create")
    end

    it "routes to #update" do
      put("/nlps/1").should route_to("nlps#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/nlps/1").should route_to("nlps#destroy", :id => "1")
    end

  end
end
