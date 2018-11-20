s = "{s:1, col:4}"

parts = s.split(",")

puts eval(s)
parts.each do |part|
  puts part
end