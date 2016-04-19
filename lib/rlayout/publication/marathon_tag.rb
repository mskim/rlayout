
# This is module for making Marathon Tag
# We can have serveral groups of marathoners with different tags.
# Top Ranked, amatures, And they are given different tags.
# So we need some information about number ranges.
# number_range array gives information about those numbers.
# number_range is given are stored in a config.yml file 
# 
# Todo
# @set difference color for number_range

# :number_range: [0..2000, 2001..3000]
# 
# "template_1.rb", "template_2.rb" file should be in the project folder

module RLayout

MarathonTemplate =<<EOF
RLayout::Document.new(portrait: false)
  page do
    text(<%= @number%>, size:24)
  end
  page do
    
  end
end

EOF

  class MarathonTag
    attr_accessor :project_path, :number_range
    
    def initialize(project_path)
      @project_path       = project_path
      config_path = @project_path + "/config.yml"
      unless File.exist?(config_path)
        puts "No config.yml file!!!"
        return
      end
      config_file = File.open(config_path, 'r'){|f| f.read}
      config_yaml = YAML::load(config_file)
      if config_yaml.class == Array
        @number_range = config_yaml.first['number_range']
      else
        @number_range = config_yaml['number_range']
      end
      @templates_path = Dir.glob("#{@project_path}/*.rb").first
      @number_range.each_with_index do |range_string, i|
        r = range_string.split("..").map(&:to_i)
        a = (r[0]..r[1]).to_a
        template = File.open(@templates_path, 'r'){|f| f.read}
        a.each do |number|
          @number = number.to_s.rjust(5,'0')
          temp = template.gsub("@number", "\"#{@number}\"")
          object = eval(temp)
          # save pdf
          output_path = @project_path + "/pdf/#{number}.pdf"
          object.save_pdf(output_path)
        end
      end
      self
    end
  end
end

