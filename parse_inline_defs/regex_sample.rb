string = "this is a test def_ruby('root', 'some', ruby_color: 'red') more text def_undertag('one', 'two')"

# result =  string.scan(/def_(.*?)\((.*?)\)/)
# m =  string.match(/(def_.*?)\((.*?)\)/)
# puts result.class
# puts result
# puts m.class
# 
InlineDefRx = /(def_.*?\(.*?\))/
# 
# result =  string.scan(InlineDefRx)
# puts "result:#{result}"
split_array = string.split(InlineDefRx)
puts "+++++"
# if string =~/def_(.+)\((.*)\)/
#   puts "it matches"
#   puts $1
#   puts $2
# else
#   puts "No match"
# end

def ruby(base, top, options={})
  __method__
  puts "base:#{base}"
  puts "top:#{top}"
  puts "options:#{options}"
end

def undertag(root, under, options={})
  __method__
  puts "base:#{root}"
  puts "under:#{under}"
  puts "options:#{options}"
end

def process_def_method(def_string)
  def_string.sub!("def_", "")
  puts "def_string: #{def_string}"
  eval(def_string)
end

split_array.each do |line|
  process_def_method(line) if line =~/def_/
end


# m = "555-333-7777".match(/(?<area>\d{3})-(?<city>\d{3})-(?<number>\d{4})/)
# puts m.class
# puts m.inspect