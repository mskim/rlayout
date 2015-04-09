# make section map from file
require 'yaml'
# require 'awesome_print'
require 'pp'

path = "/Users/Shared/SoftwareLab/news_section"

section_map = {}
Dir.glob("#{path}/**/*.yml").each do |map|
  puts dir_name = File.dirname(map)
  puts grid_category = File.basename(dir_name)
  puts article_count_name = File.basename(map, ".yml")
  puts category_key = "#{grid_category}/#{article_count_name}"
  value = YAML::load_file(map)
  section_map[category_key] = value
end

# ap section_map
pp section_map

