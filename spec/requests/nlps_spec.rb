require 'spec_helper'

describe "Nlps" do
  describe "GET /nlps" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get nlps_path
      response.should redirect_to("/")
    end
  end
end
