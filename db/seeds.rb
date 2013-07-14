# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) are set in the file config/application.yml.
# See http://railsapps.github.com/rails-environment-variables.html
require 'rubygems/package'
require 'zlib'

puts 'DEFAULT USERS'
# User.all.delete
# user = User.create! :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
# #puts 'user: ' << user.name


Nlp.all.delete
Insight.all.delete
Interest.all.delete



def index_xml_marc(file)
  reader = MARC::XMLReader.new(file, :parser => "nokogiri")
  language = file.full_name.gsub(".xml", "").gsub("videos_", "").downcase
  for record in reader
     process_record(record, language) unless record["245"].nil?
  end
end

def index_marc(file)
  puts file
  reader = MARC::Reader.new(file)
  language = File.basename(file).gsub(".mrc", "").gsub("videos_", "").downcase
  for record in reader
     process_record(record, language) unless record["245"].nil?
  end
end

def process_record(record, language)
   record_id = record["001"] ? record["001"].value : rand(0..100).to_s
   puts record_id
   # record_id = rand(0..1000000).to_s
    nlp = Nlp.create! :marc_hash => record.to_marchash, 
      :record_id => record_id, :title => record["245"]["a"], :language => language
    { "245" => "c", "508" => "a", "511" => "a", "260" => "b", "264" => "b" }.each_pair do |field,subfield|
   
      record.fields(field).each do |f|
        if f[subfield]
          f[subfield].split(";").each do |str|
         
          str = "Cast: #{str}" if field == "511" && f.indicator1 == "1"
          str = "Presenter (VM, MU) : #{str}" if field == "511" && f.indicator1 == "2"
          str = "Narrator (VM, MU) : #{str}" if field == "511" && f.indicator1 == "3"
       
           str = "Production : #{str}" if field == "264" && f.indicator2 == "0"
           str = "Publication : #{str}" if field == "264" && f.indicator2 == "1"
           str = "Distribution : #{str}" if field == "264" && f.indicator2 == "2"
           str = "Manufacture : #{str}" if field == "264" && f.indicator2 == "3"
           str = "Copyright notice date : #{str}" if field == "264" && f.indicator2 == "4"
           
           
           
          
          
            i = Interest.create(:input_field => str.strip)
            nlp.interests << i
          end
        end
      end
    end
    nlp.save
rescue ArgumentError
  puts record_id
end

Gem::Package::TarReader.new(Zlib::GzipReader.open('doc/video_xml.gz')).each do |entry|
  if [ "videos_english.xml", "videos_spanish.xml", "videos_german.xml"].include?(entry.full_name)
    puts entry.full_name
    index_xml_marc(entry)
  end  
end

Dir.glob("doc/marc/*.mrc").each do |entry|
   index_marc(entry)
end