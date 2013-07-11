require 'ner_client'
require 'marc'

class MarcProcessor
  
  include NerClient
  
  attr_accessor :nlp
  
  def initialize(nlp)
    raise ArgumentError, "NLP much have MARC hash to process" unless nlp.marc_hash
    @nlp = nlp 
  rescue Exception => e
    puts e.inspect
  end
  
  def process
    
    
    
  end
  
  
protected

  
  
  
  
end