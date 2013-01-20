require 'pp'

files_cities1 = {
"san-francisco" => "San Francisco",
"la" => "Los Angeles"
}

files1 = [
"san-francisco", 
"la" 
]

city_words1 = [
"San Francisco", 
"Los Angeles" 
]

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
"san-francisco",
"la", 
"nyc",
"chicago",
"san-diego",
"san-jose",
"seattle",
"boston",
"austin", 
"las-vegas", 
"philadelphia", 
"portland",
"houston", 
"sacramento", 
"honolulu", 
"atlanta", 
"oc", 
"denver",
"dallas",
"phoenix",
"miami" 
]

city_names = [
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
files_cities.each do |f, t|
  cnt = 1
  File.open(f,"r").each do |line|
    line.strip!
    w = line.split(/#{t}/)[0].strip
    word_freq[w] = {} if word_freq[w].nil?
    word_freq[w][f] = cnt
    cnt += 1
    break if cnt > 100
  end
end

#pp word_freq

# keyword popularity
kword_popularity = {}
word_freq.each do |k, v|
    kword_popularity[k] = v.size
end
kword_popularity = kword_popularity.sort_by { |k, v| -v }

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
files_header = ""
files.each do |c|
    files_header += "	" + c
end

city_name_header = ""
city_names.each do |c|
    city_name_header += "	" + c
end


puts "Yelp URL Slug		#{files_header}"
puts "Search Terms	Popularity	Average Ranking#{city_name_header}"
kword_popularity.each do |w,v|
    avg_rank  = ""
    kword_avg_ranking.each{|ak,av| avg_rank = av if ak == w} 
    str = "#{w}	#{v}	#{avg_rank}"
    files.each do |c|
        if word_freq[w][c].nil?
            str = str + "	" 
        else
            str = str + "	" + word_freq[w][c].to_s 
        end
    end
    puts str
end



