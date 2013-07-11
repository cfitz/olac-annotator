class Person
  
  include Mongoid::Document 
  
  field :name, :type => String
  field :marc_field, :type => String

end
  