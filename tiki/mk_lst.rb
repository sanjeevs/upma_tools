require 'pp'
database = {}
upma_lst = {} 
veda = ""
open('upma_lst.txt', 'r') do |f|
  f.readlines.each do |line|
    line.strip!
    if m = line.match(/^#(.+)/)
      veda = m[1]
      database[veda] = []
    end 
    if m = line.match(/^(.+)\s+English\s+IAST/)
      n = m[1].strip
      database[veda] << n
      upma_lst[n] = 0
    end
  end
end 
#pp database

pp upma_lst 
  
