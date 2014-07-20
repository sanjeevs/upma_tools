require 'xmlsimple'
require 'yaml'
require 'pp'

UPMA_LST = 
{"Annapurna"=>0,
 "Atharvasikha"=>0,
 "Atharvasiras"=>0,
 "Atma"=>0,
 "Bhasma-Jabala"=>0,
 "Bhavana"=>0,
 "Brihad-Jabala"=>0,
 "Dattatreya"=>0,
 "Devi"=>0,
 "Ganapati"=>0,
 "Garuda"=>0,
 "Gopala-Tapaniya"=>0,
 "Hayagriva"=>0,
 "Krishna"=>0,
 "Maha-Vakya"=>0,
 "Mandukya"=>0,
 "Mundaka"=>0,
 "Narada-Parivrajaka"=>0,
 "Nrisimha-Tapaniya"=>0,
 "Para-Brahma"=>0,
 "Paramahamsa-Parivrajaka"=>0,
 "Pasupata Brahmana"=>0,
 "Prasna"=>0,
 "Rama Rahasya"=>0,
 "Rama-Tapaniya"=>0,
 "Sandilya"=>0,
 "Sarabha"=>0,
 "Sita"=>0,
 "Surya"=>0,
 "Tripadvibhuti-Mahanarayana"=>0,
 "Tripura-Tapini"=>0,
 "Akshi"=>0,
 "Amrita-Bindu"=>0,
 "Amrita-Nada"=>0,
 "Avadhuta"=>0,
 "Brahma"=>0,
 "Brahma-Vidya"=>0,
 "Dakshinamurti"=>0,
 "Dhyana-Bindu"=>0,
 "Ekakshara"=>0,
 "Garbha"=>0,
 "Kaivalya"=>0,
 "Kalagni-Rudra"=>0,
 "Kali-Santarana"=>0,
 "Katha"=>0,
 "Katharudra"=>0,
 "Kshurika"=>0,
 "Maha-Narayana-Yajniki"=>0,
 "Pancha-Brahma"=>0,
 "Pranagnihotra"=>0,
 "Rudra-Hridaya"=>0,
 "Sarasvati-Rahasya"=>0,
 "Sariraka"=>0,
 "Sarva-Sara"=>0,
 "Skanda"=>0,
 "Suka-Rahasya"=>0,
 "Svetasvatara"=>0,
 "Taittiriya"=>0,
 "Tejo-Bindu"=>0,
 "Varaha"=>0,
 "Yoga-Kundalini"=>0,
 "Yoga-Sikha"=>0,
 "Yoga-Tattva"=>0,
 "Aitareya"=>0,
 "Aksha-Malika"=>0,
 "Atma-Bodha"=>0,
 "Bahvricha"=>0,
 "Kaushitaki-Brahmana"=>0,
 "Mudgala"=>0,
 "Nada-Bindu"=>0,
 "Nirvana"=>0,
 "Saubhagya-Lakshmi"=>0,
 "Tripura"=>0,
 "Aruni_Aruneyi"=>0,
 "Avyakta"=>0,
 "Chandogya"=>0,
 "Darsana"=>0,
 "Jabali"=>0,
 "Kena"=>0,
 "Kundika"=>0,
 "Maha"=>0,
 "Maitrayani"=>0,
 "Maitreya"=>0,
 "Rudraksha-Jabala"=>0,
 "Sannyasa"=>0,
 "Savitri"=>0,
 "Vajrasuchika"=>0,
 "Vasudeva"=>0,
 "Yoga-Chudamani"=>0,
 "Adhyatma"=>0,
 "Advaya-Taraka"=>0,
 "Bhikshuka"=>0,
 "Brihadaranyaka"=>0,
 "Brihadaranyaka_1"=>0,
 "Brihadaranyaka_2"=>0,
 "Brihadaranyaka_3"=>0,
 "Brihadaranyaka_4"=>0,
 "Brihadaranyaka_5"=>0,
 "Brihadaranyaka_6"=>0,
 "Hamsa"=>0,
 "Isavasya"=>0,
 "Jabala"=>0,
 "Mandala-Brahmana"=>0,
 "Mantrika"=>0,
 "Muktika"=>0,
 "Niralamba"=>0,
 "Paingala"=>0,
 "Paramahamsa"=>0,
 "Satyayaniya"=>0,
 "Subala"=>0,
 "Tara-Sara"=>0,
 "Trisikhi-Brahmana"=>0,
 "Turiyatita-Avadhuta"=>0,
 "Yajnavalkya"=>0}

 
def create_verses(content) 
  verses = []
  verse = ""
  first_line = true 
  content.each_line do |line|
    #Checks on each line
    puts line unless line.valid_encoding?
    temp = line.split(//).map { |c| c.ascii_only? ? '' : c }
    line = temp.join

    #Cleanup
    line.strip!
    line.gsub!(/\t/, ' ')

    #Add a newline after each continuation
    line += "\n" if( line =~ /[\u{0964}]/ )
    verse += line
    if line =~ /[\u{0965}]/ 
      verses << verse
      verse = ""
    end
  end
  verses
end



data = XmlSimple.xml_in('tiki_pages.xml')


accumulate_brihadarynaka = {} 
data["database"][0]["table"].each do |e|
  name = e["column"][1]["content"]
  m = name.match /UP_(.+)/
  if m
   up_name = m[1]
   up_name = "Isavasya" if up_name == "Isha"
   up_name = "Kaushitaki-Brahmana" if up_name == "Kaushitaki"
   up_name = "Svetasvatara" if up_name == "Shvetasvatara"
   up_name = "Aruni_Aruneyi" if up_name == "Aruni.Aruneyi"
   up_name = "Maha-Narayana-Yajniki" if up_name == "Maha-Narayana.Yajniki"
  
   UPMA_LST[up_name] += 1 
   verses = create_verses(e["column"][3]["content"]) 
   
   if up_name =~ /Brihadaranyaka/ 
     accumulate_brihadarynaka[up_name] = verses
   else
    database = {}
    #Read the verses and try to guess the name of upanishad 
    database[up_name] = verses
    open("in/" + up_name + ".rb", 'w') do |f| 
      key = database.keys[0]
      value = database.values[0]
      f.puts("database[\"#{key}\"] = #{value}") 
    end 
   end
  end
end

#Combine the Brihadaryaka into a single entry.
final = [
  accumulate_brihadarynaka["Brihadaranyaka"],
  accumulate_brihadarynaka["Brihadaranyaka_1"],
  accumulate_brihadarynaka["Brihadaranyaka_2"],
  accumulate_brihadarynaka["Brihadaranyaka_3"],
  accumulate_brihadarynaka["Brihadaranyaka_4"],
  accumulate_brihadarynaka["Brihadaranyaka_5"],
  accumulate_brihadarynaka["Brihadaranyaka_6"],
  ].flatten
 open("in/" + "Brihadaranyaka" + ".rb", 'w') do |f| 
  key = "Brihadaranyaka" 
  f.puts("database[\"#{key}\"] = #{final}") 
 end   

#open('verses.yaml', 'w') { |f| f.puts database.to_yaml }

#open('verses.bin', 'wb') { |f| f.print Marshal::dump(database) }


