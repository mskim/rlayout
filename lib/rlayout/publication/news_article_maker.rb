SAMPLE_RAKEFILR =<<EOF
source_files = FileList["*.md", "*.markdown"]
task :default => :pdf
task :pdf => source_files.ext(".pdf")

rule ".pdf" => ".md" do |t|
  sh "/Users/mskim/Development/Rubymotion/rlayout/build/MacOSX-10.10-Development/rlayout.app/Contents/MacOS/rlayout news_article \#{pwd}/\#{t.source}"
end

rule ".pdf" => ".markdown" do |t|
  sh "/Users/mskim/Development/Rubymotion/rlayout/build/MacOSX-10.10-Development/rlayout.app/Contents/MacOS/rlayout news_article \#{pwd}/\#{t.source}"
end

EOF

SAMPLE_NEWS_ARTICLE =<<EOF
---
title: 'This is a title'
grid_frame: <%= @grid_frame %>
grid_size: [188.188571428571, 158.674166666667]

author: 'Min Soo Kim'
---

This is where sample stroy text goes. Fill in this area with your story. This is where sample stroy text goes.
Fill in this area with your story.

This is the second paragraph. You could keep on writting until it fills up the box.

The box size is determined by grid_frame value at the top. It is usually looks somethink like grid_frame: [0,0,4,6]
The first value is x, y, width, height. So this the box will have size of 4 grid wide and 6 grid tall.


EOF

module RLayout
  class NewsArticleMaker
    attr_accessor :path, :output_path, :output_folder
    def initialize(path, options={})
      @path          = path
      @content_path  = path
      ext            = File.extname(@path)
      @output_path   = @path.gsub(ext, ".pdf")
      @output_folder = File.dirname(@path)
      options[:story_path]   = @content_path
      options[:output_path]  = @output_path
      process_job(options) if valid_job?
      self
    end

    def valid_job?
      unless File.exist?(@path)
        puts "#{@path} does not exist!!! "
        return false
      end
      unless File.exist?(@content_path)
        puts "#{@path} does not exist!!! "
        return false
      end
      true
    end

    def process_job(options)
      system("mkdir -p #{@output_folder}") unless File.exist?(@output_folder)
      NewsArticle.new(nil, options)
    end


    # def self.create_section(folder_path)
    #   #copy_section_template(folder_path, opiotions={})
    #   article_grid_frames = File.open(template_path,'r'){|f| f.read}.load_yaml
    #   article_grid_frames.each_with_index do |grid_frame, i|
    #     self.update_article_grid_base(articles[i], grid_frame)
    #   end
    #
    # end

    # def self.update_article_grid_base
    #
    # end

    def self.sample(folder_path, number_of_stories)
      grid_base = '7x11'
      template_path = "/Users/Shared/SoftwareLab/news_section/#{grid_base}/#{number_of_stories}.yml"
      grid_file = File.open(template_path, 'r'){|f| f.read}
      grid_map = YAML::load(grid_file)
      system("mkdir -p #{folder_path}") unless File.exist?(folder_path)
      number_of_stories.times do |i|
        path = folder_path + "/#{i + 1}.story.md"
        @grid_frame = grid_map[i]
        sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @grid_frame %>", @grid_frame.to_s)
        File.open(path, 'w'){|f| f.write sample}
      end
      path = folder_path + "/Rakefile"
      File.open(path, 'w'){|f| f.write SAMPLE_RAKEFILR} unless File.exist?(path)

    end
  end
end
