require 'pp'

files1 = {
"san-francisco" => "San Francisco",
"la" => "Los Angeles"
}

files_cities = {
"san-francisco" => "San Francisco",
"la" => "Los Angeles",
"nyc" => "New York",
"chicago" => "Chicago",
"san-diego" => "San Diego",
"san-jose" => "San Jose",
"seattle" => "Seattle",
"boston" => "Boston",
"austin" => "Austin",
"las-vegas" => "Las Vegas",
"philadelphia" => "Philadelphia",
"portland" => "Portland",
"houston" => "Houston",
"sacramento" => "Sacramento",
"honolulu" => "Honolulu",
"atlanta" => "Atlanta",
"oc" => "Orange County",
"denver" => "Denver",
"dallas" => "Dallas",
"phoenix" => "Phoenix",
"miami" => "Miami"
}

files = [
"san-francisco" => "San Francisco",
"la" => "Los Angeles",
"nyc" => "New York",
"chicago" => "Chicago",
"san-diego" => "San Diego",
"san-jose" => "San Jose",
"seattle" => "Seattle",
"boston" => "Boston",
"austin" => "Austin",
"las-vegas" => "Las Vegas",
"philadelphia" => "Philadelphia",
"portland" => "Portland",
"houston" => "Houston",
"sacramento" => "Sacramento",
"honolulu" => "Honolulu",
"atlanta" => "Atlanta",
"oc" => "Orange County",
"denver" => "Denver",
"dallas" => "Dallas",
"phoenix" => "Phoenix",
"miami" => "Miami"
]


city_words = [
"San Francisco",
"Los Angeles",
"New York",
"Chicago",
"San Diego",
"San Jose",
"Seattle",
"Boston",
"Austin",
"Las Vegas",
"Philadelphia",
"Portland",
"Houston",
"Sacramento",
"Honolulu",
"Atlanta",
"Orange County",
"Denver",
"Dallas",
"Phoenix",
"Miami"
]

word_freq = {}
files.each do |f, t|
  cnt = 1
  File.open(f,"r").each do |line|
    line.strip!
    w = line.split(/#{t}/)[0].strip
    word_freq[w] = {} if word_freq[w].nil?
    word_freq[w][t] = cnt
    cnt += 1
    break if cnt > 100
  end
end

#pp word_freq

kword_avg_ranking = {}
word_freq.each do |k, v|
    sum = 0
    v.each do |i| 
      sum += i[1]
    end
    avg = sum.to_f / v.size
    kword_avg_ranking[k] = avg
end

kword_avg_ranking = kword_avg_ranking.sort_by { |k, v| v }

# print in tsv format
# print header
cities_header = ""
all_cities.each do |c|
    cities_header += "	" + c
end

puts "Search Terms	Ranking#{cities_header}"
kword_avg_ranking.each do |w,v|
    str = "#{w}	#{v}"
    all_cities.each do |c|
        if word_freq[w][c].nil?
            str = str + "	" 
        else
            str = str + "	" + word_freq[w][c].to_s 
        end
    end
    puts str
end



