# require 'rlayout' #install rlayout in in the system ruby

require 'yaml'

puts @styles = YAML::load_file(File.dirname(__FILE__) + "/../styles.rb")


path = File.dirname(__FILE__) + "/../content.md"
unless File.exists?(path)
  puts "File named content.md does not exist!!!!"
end

content = File.open(path, 'r'){|f| f.read}
puts content