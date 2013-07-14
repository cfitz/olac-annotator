require 'marc'

# http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/
class Nlp
  
  include Mongoid::Document
  validates_with InsightValidator

  
  scope :need_approval, where(:needs_approved_counter.gt => 0 ).order_by(:need_approved_counter => :asc)
  
#  field :marc_string, :type => String
  field :marc_hash, :type => Hash  
  field :record_id, :type => String
  field :title, :type => String
  field :language, :type => String
  
  field :authority_names, :type => Array
  before_validation :set_authority_names
  before_save :update_approved_counter  

  has_many :interests
  accepts_nested_attributes_for :interests
  
  field :interest_count, :type => Integer, :default => 0
  field :approved_counter, :type => Integer, :default => 0
  field :needs_approved_counter, :type => Integer, :default => 0

  attr_accessor :comment, :role_language, :language_comment
  
  index({ language: 1 }, { unique: false })
  
  def to_marc
    self.marc_hash ? convert_hash_to_marc(self.marc_hash)   : ""
  end
  
  def updated_to_marc
    self.updated_marc_hash ? convert_hash_to_marc(self.updated_marc_hash)   : ""
  end
  
  def canonical_names
    results = [ [ "No matching name in list", "" ]]
    names = self.authority_names
    names.each {|n| results << ["#{n["name"]}", n["name"]]}
    results
  end
    
  def next
    self.class.find(:conditions => {:_id => {$gt => self._id }, :language => self.language }).sort({:_id=>1}).limit(1)
  end
  
  # this is an terrible hack to get the comments fixed. 
  def update_comments
    self.interests.each do |int|
      int.insights.each do |ins|
        ins.save
      end
    end
  end
  
  protected
  
  
  def update_approved_counter
    self.approved_counter = 0 
    self.needs_approved_counter = 0
    self.interests.each { |interest| interest.insights.each { |i| i.approved? ? self.approved_counter += 1 : self.needs_approved_counter += 1  } }    
  end
  
  def set_authority_names
    unless self.marc_hash.nil?
       results = []
       marc = MARC::Record.new_from_marchash(self.marc_hash)
       [ "100", "700"].each do |field|
          marc.fields(field).each_with_index do |str, index|
              results << { :name => str["a"].chomp("."), :field => "#{field}-00#{index.to_s}", :record_id => self.record_id }
          end
       end
       
       [ "110", "710"].each do |field|
           marc.fields(field).each_with_index do |str, index|
             if str['a']
               name = "#{str['a'].chomp('.')}"
               name << " -- #{str['b'].chomp('.')}" if str['b']
               results << { :name => name, :field => "#{field}-00#{index.to_s}", :record_id => self.record_id }
             end
           end
        end
        
       self.authority_names = results.sort_by { |r| r[:name] }
    end
  end
  
  
  def ensure_marc_hash
     if marc_string.blank?
        self.marc_hash = MARC::Reader.new(Rails.root.join("doc/sample.mrc").to_s).first.to_marchash
      else
        self.marc_hash = MARC::Reader.new(StringIO.new(marc_string)).first.to_marchash
      end
  end
  

  
  def convert_hash_to_marc(hash = {} )
    MARC::Record.new_from_marchash(hash).to_s  
  end
  
  def self.get_random_record_by_language(language)
    nlps = Nlp.where(language: language, :approved_counter.lt => 3)
    cnt = ( nlps.count - 1 ) 
    offset = rand(cnt)
    nlps.skip(offset).limit(1).first
  end
  
  
  
    
end
