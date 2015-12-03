
require 'yaml'
yaml_path = "sample_story.yml"
puts yaml = YAML::load_file(yaml_path)
# yaml = File.open(yaml_path, 'r'){|f| f.read}

puts "++++++"
puts yaml.keys
puts yaml['table']