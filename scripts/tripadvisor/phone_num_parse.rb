
js_text = "<!--
function escramble_133(){
var a,b,c
a='1-8'
b='6-2'
a+='88-2'
b+='427'
c='3'
document.write(a+c+b)
}
escramble_133()
//-->"


a = ''
b = ''
c = ''

js_text.split("\n").each do |line|
    if (line.match(/=/))
        parts = line.split(/=/)
        if parts[0] == "a"
            a = parts[1]
        elsif parts[0] == "a+"
            a = a + parts[1]
        elsif parts[0] == "b"
            b = parts[1]
        elsif parts[0] == "b+"
            b = b + parts[1]
        elsif parts[0] == "c"
            c = parts[1]
        end
    end
end

phone_num = a.to_s + c.to_s + b.to_s

puts phone_num.gsub(/'/, '')



