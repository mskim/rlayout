# require 'yaml'
# yaml_path = "sample_paradata.yml"
# puts yaml = YAML::load_file(yaml_path)
# # yaml = File.open(yaml_path, 'r'){|f| f.read}
# 
# puts "++++++"
# puts yaml.keys
# puts yaml['table']

path = "/Users/mskim/Development/HWP/section_test1"
path = "/Users/mskim/Development/HWP/ms"
path = "/Users/mskim/Development/HWP/table_test"

system("/Applications/magazine.app/Contents/MacOS/magazine #{path}")

