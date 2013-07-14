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
  [ ["Select", "" ], ["no role specified", "no role specified"], ["I don't know what the language is", "I don't know what the language is"], ["Language not in list", "Language not in list"], ["English", "English"], ["Arabic", "Arabic"], ["Armenian", "Armenian"], ["Balinese", "Balinese"], ["Bengali", "Bengali"], ["Bosnian", "Bosnian"], ["Bulgarian", "Bulgarian"], ["Chinese", "Chinese"], ["Croatian", "Croatian"], ["Czech", "Czech"], ["Danish", "Danish"], ["Dutch", "Dutch"], ["Estonian", "Estonian"], ["Farsi/Persian", "Farsi/Persian"], ["Finnish", "Finnish"], ["French", "French"], ["Georgian", "Georgian"], ["German", "German"], ["Greek", "Greek"], ["Hebrew", "Hebrew"], ["Hindi", "Hindi"], ["Hungarian", "Hungarian"], ["Icelandic", "Icelandic"], ["Indonesian", "Indonesian"], ["Italian", "Italian"], ["Japanese", "Japanese"], ["Kazak", "Kazak"], ["Korean", "Korean"], ["Kurdish", "Kurdish"], ["Lao", "Lao"], ["Latvian", "Latvian"], ["Lithuanian", "Lithuanian"], ["Macedonian", "Macedonian"], ["Malay", "Malay"], ["Norwegian", "Norwegian"], ["Panjabi", "Panjabi"], ["Pashto", "Pashto"], ["Polish", "Polish"], ["Portuguese", "Portuguese"], ["Rumanian", "Rumanian"], ["Russian", "Russian"], ["Serbian", "Serbian"], ["Serbo-Croatian (unspecified)", "Serbo-Croatian (unspecified)"], ["Sindhi", "Sindhi"], ["Slovenian", "Slovenian"], ["Spanish", "Spanish"], ["Swedish", "Swedish"], ["Tagalog", "Tagalog"], ["Tajik", "Tajik"], ["Tamil", "Tamil"], ["Thai", "Thai"], ["Turkish", "Turkish"], ["Uighur", "Uighur"], ["Urdu", "Urdu"], ["Uzbek", "Uzbek"], ["Vietnamese", "Vietnamese"]]
  
  end
  
 
end
