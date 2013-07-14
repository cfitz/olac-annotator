class Insight
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :role_language, :presence => { :message => "The language field cannot be blank." }
  
  embedded_in :interest, inverse_of: :interests

  field :raw_name, :type => String
  field :canonical_name, :type => String
  field :raw_role, :type => String
  field :role, :type => String
  field :approved, :type => Boolean, :default => false
  field :role_language, :type => String # this is the language identifed by the annotator.
  field :comment, :type => String
  field :language_comment, :type => String
  
  def self.role_values
   [ [ "Not On List", ""], ["adaptation", "adaptation"], ["animator", "animator"], ["art director", "art director"], ["cinematographer", "cinematographer"], ["conductor", "conductor"], ["costume designer", "costume designer"], ["director", "director"], ["editor", "editor"], ["music", "music"], ["narrator", "narrator"], ["presents", "presents"], ["producer", "producer"], ["production designer", "production designer"], ["set decorator", "set decorator"], ["writer", "writer"]]
  end
  
  def self.language_values
      [  ["no role specified", "no role specified"], ["I don't know what the language is", "i don't know what the language is"], ["Language not in list", "language not in list"], ["English", "english"], ["Arabic", "arabic"], ["Armenian", "armenian"], ["Balinese", "balinese"], ["Bengali", "bengali"], ["Bosnian", "bosnian"], ["Bulgarian", "bulgarian"], ["Chinese", "chinese"], ["Croatian", "croatian"], ["Czech", "czech"], ["Danish", "danish"], ["Dutch", "dutch"], ["Estonian", "estonian"], ["Farsi/Persian", "farsi/persian"], ["Finnish", "finnish"], ["French", "french"], ["Georgian", "georgian"], ["German", "german"], ["Greek", "greek"], ["Hebrew", "hebrew"], ["Hindi", "hindi"], ["Hungarian", "hungarian"], ["Icelandic", "icelandic"], ["Indonesian", "indonesian"], ["Italian", "italian"], ["Japanese", "japanese"], ["Kazak", "kazak"], ["Korean", "korean"], ["Kurdish", "kurdish"], ["Lao", "lao"], ["Latvian", "latvian"], ["Lithuanian", "lithuanian"], ["Macedonian", "macedonian"], ["Malay", "malay"], ["Norwegian", "norwegian"], ["Panjabi", "panjabi"], ["Pashto", "pashto"], ["Polish", "polish"], ["Portuguese", "portuguese"], ["Rumanian", "rumanian"], ["Russian", "russian"], ["Serbian", "serbian"], ["Serbo-Croatian (unspecified)", "serbo-croatian (unspecified)"], ["Sindhi", "sindhi"], ["Slovenian", "slovenian"], ["Spanish", "spanish"], ["Swedish", "swedish"], ["Tagalog", "tagalog"], ["Tajik", "tajik"], ["Tamil", "tamil"], ["Thai", "thai"], ["Turkish", "turkish"], ["Uighur", "uighur"], ["Urdu", "urdu"], ["Uzbek", "uzbek"], ["Vietnamese", "vietnamese"] ]
  end
  
 
end
