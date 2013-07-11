require 'spec_helper'

describe Nlp do
  
  before(:each) do
    @nlp = FactoryGirl.build(:nlp)
  end
  
  describe "initalize" do 
    it "should initalize correctly without an input" do
      @nlp.should be_an_instance_of(Nlp)
      @nlp.marc_hash.should be_nil
      @nlp.save
      @nlp.marc_hash.should be_an_instance_of(Hash)
    end

    it "should initalize correclty with an input" do
      new_nlp = Nlp.new({:marc_string => IO.read(Rails.root.join("doc/sample.mrc"))})
      new_nlp.save
      new_nlp.marc_hash == @nlp.marc_hash
    end
  end
  
  it "should return proper marc" do
    @nlp.to_marc.should == ""
    @nlp.save
    @nlp.to_marc.should include("produced by Kodansha in association with Bandai Visual and Manga Entertainment ; producers, Yoshimasa Mizuo ...")    
  end
  
end
