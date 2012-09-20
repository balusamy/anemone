require 'choice'
require 'crawler'

Choice.options do
  option :source, :required => true do
    short "-s"
    long "--source"
    desc "Source adapter"
  end

end

s = Choice.choices[:source]
if s && s.to_s != ""
  puts "Using source adapter :#{s}"
else
  puts "Specify a source"
  exit
end

engine = Crawler.new()
engine.run(s)


