require 'pp'

filelst = Dir.entries("./in/")
database = {}

filelst.each do |f|
  next if f == '.' or f == '..'
  next unless f.match /\.rb/
  s = ""
  s = File.open("./in/" + f).read
  puts "Evaluating file " + f
  eval(s)
end

puts "Number of entries=" + database.size.to_s
open("tiki_migration.rake", "w") do |f|
  f.puts "#encoding: utf-8"
  f.puts "namespace :db do"
  f.puts "  desc 'Fill database with data from tiki pages'"
  f.puts "  task initialize: :environment do"
  f.print"    database = "
  PP.pp database, f

f.print <<EOF
    database.each do |key, verses| 
      upanishad = Upanishad.create!(name: key)
      i = 100
      puts "Starting Upanishad " + key + ". Verses=" + verses.size.to_s
      verses.each do |v|
         upanishad.verses.create!(content:v, position: i)
         i += 100
      end
    end
  end
end  
EOF
        
end
