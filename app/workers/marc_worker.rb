class MarcWorker
  # include Sidekiq::Worker
  
  
  # todo: this will run the marc processor in sidekiq.
  def perform(marc_hash)
  #  MarcProcessor
 
  end
  
  
  
end