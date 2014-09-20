#
# require 'rlayout' #install rlayout in in the system ruby

require 'yaml'

styles_path = File.dirname(__FILE__) + "/../styles.rb"

if File.exits?(styles_path)
  puts @styles = YAML::load_file(styles_path)
end

path = File.dirname(__FILE__) + "/../content.md"
unless File.exists?(path)
  puts "File named content.md does not exist!!!!"
end

content = File.open(path, 'r'){|f| f.read}
puts content