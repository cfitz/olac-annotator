# simple wrapper for the Calais API

module NerClient
  
  
  def enlighten(string="")
    Calais.process_document( :content => string, :conent_type => :raw, :license_id => 
  end
  
end