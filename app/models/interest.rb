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
  
 

  def new_session_insights_attributes=(args={})
    puts args
=begin
    args.each_pair do |k,v|
      destroy = v["__destroy"] == "1"
      if k.include?("new") or v["id"].empty? # this is a newly added relationship
        unless destroy
          self << 
          self.save #first we need to persist the document. 
          creator = v["class"].constantize.find_or_create_by(:name => v["end_node_name"])
          creator_role = Creator.new(:creators, self, creator, {:role => v["role"] })
          creator_role.save
        end
      else # existing relationship, lets check it. 
        if destroy 
          creator = Creator.find(v["id"])
          creator.destroy 
        else
          creator = Creator.find(v["id"])
          unless creator.role == v["role"]
            creator.role = v["role"]
            creator.save
          end
        end
      end
=end
    end


end
