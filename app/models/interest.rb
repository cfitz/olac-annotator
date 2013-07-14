class Interest
  
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::MagicCounterCache
 
  belongs_to :nlp
  embeds_many :insights
  accepts_nested_attributes_for :insights #, :reject_if => proc { |attributes| attributes['raw_name'].blank? }
  #validates_associated :insights
  counter_cache :nlp


  field :input_text, :type => String
  field :position, :type => Integer
  field :input_field, :type => String
 
  # this method makes sure that the new session have a clear set of insights
  def new_session_insights
    self.insights.build
  end
  


end
