
# This is module for making Marathon Tag
# We can have serveral groups of marathoners with different tags.
# Top Ranked, amatures, And they are given different tags.
# So we need some information about number ranges.
# number_range array gives information about those numbers.
# templates_array indicates which layout template to use for number range.
# number_range is given are stored in a config.yml file 
# 
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

EOF

  class MarathonTag
    attr_accessor :project_path, :number_range, :templates_array
    
    def initialize(project_path)
      puts "project_path:#{project_path}"
      @project_path       = project_path
      config_path = @project_path + "/config.yml"
      unless File.exist?(config_path)
        puts "No config.yml file!!!"
        return
      end
      config_file = File.open(config_path, 'r'){|f| f.read}
      config_yaml = YAML::load(config_file)
      @number_range = config_yaml[:number_range]
      @templates_array = []
      Dir.glob("#{@project_path}/*.rb").each do |path|
        @templates_array << path
      end
      
      @number_range.each_with_index do |range_string, i|
        r = range_string.split("..").map(&:to_i)
        a = (r[0]..r[1]).to_a
        template = File.open(@templates_array[i], 'r'){|f| f.read}
        template = template.gsub("<%= @number%>", "\"#{@number}\"")
        puts "template:#{template}"
        
        a.each do |number|
          @number = number.to_s.rjust(5,'0')
          object = eval(template)
          puts "object.class:#{object.class}"
          # save pdf
          output_path = @project_path + "/pdf/#{numbrt}.pdf"
          object.save_pdf(output_path)
        end
      end
      self
    end
  end
end

require 'minitest/autorun'
include RLayout

describe 'create MarathonTag' do
  before do
    @project_path = "/Users/mskim/rjob_demo/variables/marathon_tag"
    @marathon      = MarathonTag.new(@project_path)
  end
  
  it 'should create MarathonTag' do
    assert @marathon.class ==MarathonTag
  end
  
  
end