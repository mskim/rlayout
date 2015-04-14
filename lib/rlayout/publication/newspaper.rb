# encoding: utf-8


SECTION_RAKE_FILE =<<EOF
task :default => 'section.pdf'

source_files = FileList["*.md", "*.markdown"]
task :pdf => source_files.ext(".pdf")
rule ".pdf" => ".md" do |t|
  sh "/Users/mskim/Development/Rubymotion/rlayout/build/MacOSX-10.10-Development/rlayout.app/Contents/MacOS/rlayout news_article \#{pwd}/\#{t.source}"
end
rule ".pdf" => ".markdown" do |t|
  sh "/Users/mskim/Development/Rubymotion/rlayout/build/MacOSX-10.10-Development/rlayout.app/Contents/MacOS/rlayout news_article \#{pwd}/\#{t.source}"
end

file 'section.pdf' => source_files.ext(".pdf") do |t|
  sh "/Users/mskim/Development/Rubymotion/rlayout/build/MacOSX-10.10-Development/rlayout.app/Contents/MacOS/rlayout news_section \#{pwd}"
end

EOF

SAMPLE_NEWS_ARTICLE =<<EOF
---
title: 'This is a title for Story<%= @story_index %>'
grid_frame: <%= @grid_frame %>
grid_size: [<%= @grid_width %>, <%= @grid_height %>]

author: 'Min Soo Kim'
---

This is where sample story text goes. Fill in this area with your story. This is where sample story text goes.
Fill in this area with your story.

This is the second paragraph. You could keep on writting until it fills up the box.

The box size is determined by grid_frame value at the top. It is usually looks somethink like grid_frame: [0,0,4,6]
The first value is x, y, width, height. So this the box will have size of 4 grid wide and 6 grid tall.


EOF

DEFAULT_SECTIONS = %w{current sports culture technology}

DEFAULT_SECTIONS2 = %w{Current Politics Economy Entertainment Sports Culture Technology }

module RLayout

  class Newspaper
    attr_accessor :name, :publication_path, :sections
    attr_accessor :grid_base, :grid_width, :grid_height, :lines_in_grid, :gutter
    def initialize(name, options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @name         = options.fetch(:name, "OurTimes")
      @publication_path = options[:path] || "/Users/Shared/Newspaper/#{@name}"
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      @sections     = options.fetch(:sections, DEFAULT_SECTIONS.dup)
      @lines_in_grid= options.fetch(:lines_in_grid, 10)
      @gutter       = options.fetch(:gutter, 10)
      @v_gutter     = options.fetch(:v_gutter, 0)
      @left_margin  = options.fetch(:left_margin, 50)
      @top_margin   = options.fetch(:top_margin, 50)
      @right_margin = options.fetch(:right_margin, 50)
      @bottom_margin= options.fetch(:bottom_margin, 50)
      @grid_base    = options.fetch(:grid_base, [7, 12])
      @grid_width   = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height  = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      setup
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    def setup
      system "mkdir -p #{@publication_path}" unless File.exist?(@publication_path)
      save_config_file
    end
    
    def save_config_file
      config_path = @publication_path + "/config.yml"
      File.open(config_path, 'w'){|f| f.write publication_info.to_yaml}
    end
    
    def create_new_issue(options={})
      NewspaperIssue.new(@publication_path, options)
    end
    
    def publication_info
      info = {}
      info['name']        = @name
      info['sections']    = @sections
      info['width']       = @width
      info['height']      = @height
      info['left_margin'] = @left_margin
      info['top_margin']  = @top_margin
      info['right_margin']= @right_margin
      info['botoom_margin']= @botoom_margin
      info['grid_base']   = @grid_base
      info['grid_width']  = @grid_width
      info['grid_height'] = @grid_height
      info['gutter']      = @gutter
      info['v_gutter']    = @v_gutter
      info['lines_in_grid']= @lines_in_grid
      info
    end

    def page_lines
      @lines_in_grid * @grid_base[1]
    end

    def line_height
      (@height - @top_margin - @bottom_margin)/page_lines
    end

  end



  class NewspaperIssue
    attr_accessor :publication_path, :issue_date, :issue_path
    attr_accessor :issue_path, :issue_number, :issue_date
    def initialize(publication_path, options={})
      @publication_path = publication_path
      @issue_date  = options.fetch(:issue_date, "2015-4-5")
      @issue_path = @publication_path + "/" + @issue_date
      create_sections
      self
    end
        
    def create_sections
      publication_config = File.open(@publication_path + "/config.yml", 'r'){|f| f.read}
      @publication_info = YAML::load(publication_config)
      @publication_info['sections'].each_with_index do |section_name, i|
        section_path = @issue_path + "/#{section_name}"
        output_path = section_path + "/section.pdf"
        if i== 0
          news_section = NewspaperSection.new(nil, :section_path=>section_path, :output_path=> output_path, :has_heading=>true)
        else
          news_section = NewspaperSection.new(nil, :section_path=>section_path, :output_path=> output_path)
        end
        news_section.create
        news_section.update_section
      end
    end
    
  end

  # NewspaperSection is a sinlge page of a Newspaper
  # NewspaperSection can have many articles.
  # NewspaperSection can have heading part or none, depending on the setion type
  # Once the layout out of the section is set,
  # each article is layouted independently by the reporter who is working on the article.
  # each article is produced as PDF image and mergerd with rest of the articles.
  # If section layout is changed, each reporteds will have to adjust their articles to fit new new layout.

  class NewspaperSection < Page
    attr_accessor :section_path, :issue_numner, :date, :publication, :issue, :date, :section_name, :output_path
    attr_accessor :has_heading, :heading_info, :paper_size
    attr_accessor :heading_type #none, top, left_top_box,
    attr_accessor :articles_info, :grid_map, :grid_key

    def initialize(parent_graphic, options={}, &block)
      super
      @parent_graphic = parent_graphic
      @section_path   = options[:section_path] if options[:section_path]
      @output_path    = @section_path + "/section.pdf"
      @output_path    = options[:output_path]   if options[:output_path]      
      @paper_size     = options.fetch(:paper_size,"A2")
      @width          = SIZES[@paper_size][0]
      @height         = SIZES[@paper_size][1]
      @width          = options['width'] if options['width']
      @height         = options['height'] if options['height']
      @lines_in_grid  = options.fetch(:lines_in_grid, 10)
      @gutter         = options.fetch(:gutter, 10)
      @v_gutter       = options.fetch(:v_gutter, 0)
      @left_margin    = options.fetch(:left_margin, 50)
      @top_margin     = options.fetch(:top_margin, 50)
      @right_margin   = options.fetch(:right_margin, 50)
      @bottom_margin  = options.fetch(:bottom_margin, 50)
      @grid_base      = options.fetch(:grid_base, [7, 12])
      @has_heading    = options[:has_heading] || false
      @number_of_article = options.fetch(:number_of_article, 5)      
      @grid_width     = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height    = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      @grid_key       = "#{@grid_base.join("x")}"
      @grid_key      += "H" if @has_heading
      @grid_key      += "/#{@number_of_article}"
      @grid_map       = GRID_PATTERNS[@grid_key]
      if options['grid_key']
        @grid_key     = options['grid_key'] 
        @grid_map     = GRID_PATTERNS["#{@grid_key}"]
        @has_heading = grid_key.split("/")[0]=~/H$/ ? true : false
        @grid_map = GRID_PATTERNS[@grid_key]
        @number_of_article = @grid_map.length      
      end      
      @articles_info= make_articles_info
      if block
        instance_eval(&block)
      end
      self
    end
    
    def self.open(path)
      config_path = path + "/config.yml"
      config = File.open(config_path, 'r'){|f| f.read}
      options = YAML::load(config)
      options[:section_path] = path
      NewspaperSection.new(nil, options)
    end
    
    # Run rake to update pdf files in section folder
    def update_section
      system ("cd #{@section_path} && rake")
    end
        
    #TODO
    # Change section layout with given grid_key(grid_pattern)
    def change_section_layout(grid_key, options={})
      if @grid_key == grid_key
        puts "new pattern is same as the old one!!!"
        return
      end 
      unless GRID_PATTERNS[grid_key]
        puts "There is no grid_key as #{grid_key}"
        return
      end
      @grid_key = grid_key
      @has_heading = @grid_key.split("/")[0] =~/H$/ ? true : false
      @grid_map = GRID_PATTERNS[@grid_key]

      # update config 
      section_config_path = @section_path + "/config.yml"
      section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      
      @number_of_article.times do |i|
        new_metadata = {}
        new_metadata['has_heading'] = @has_heading
        if @has_heading
          new_metadata['grid_frame'] = @grid_map[i + 1].to_s
        else
          new_metadata['grid_frame'] = @grid_map[i + 1].to_s
        end
        new_metadata['grid_size'] = [@grid_width, @grid_height].to_s
        story_path =  @section_path + "/#{i + 1}.story.md"
        if File.exist?(story_path)
          Story.update_metadata(story_path, new_metadata)
        else
          # Need to create more story for new pattern
          sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @grid_frame %>", @grid_frame.to_s)
          sample = sample.gsub("<%= @grid_width %>", @grid_width.to_s)
          sample = sample.gsub("<%= @grid_height %>", @grid_height.to_s)
          sample = sample.gsub("<%= @story_index %>", (story_index + 1).to_s)
          File.open(story_path, 'w'){|f| f.write sample}
        end
      end
    end
          	
    def make_section_config
      # Rubymotion YAML kit doesn't seem to work with symbols it reads symbols as ':key' String.
      # So, to make it work, I am saving keys  as String instead of symbol
      # It can play nicely since I could distinguish whether the options are coming from new or open
      # for  NewSection new, options keys are passed as symbols,
      # And for  NewSection open, options keys are stored as String, when read from section config file.
      info ={}
      info['publication'] = @publication || "OurTimes"
      info['issue']       = @issue       || '100-100'
      info['date']        = @date         || '2015-4-5'
      info['section_name']= @section_name || "untitled"
      info['has_heading'] = @has_heading
      info['grid_key']    = @grid_key
      info['width']       = @width
      info['height']      = @height
      # info[:left_margin]  = @left_margin
      # info[:right_margin] = @right_margin
      # info[:top_margin]   = @top_margin
      # info[:bottom_margin]= @bottom_margin
      # info[:gutter]       = @gutter
      info
    end
    
    def make_articles_info
      @article_info = []
      @grid_map.each_with_index do |grid_frame, i|
        info = {}
        if @has_heading && i == 0
          info[:image_path] = @section_path + "/heading.pdf"
        elsif @has_heading && i >= 0
          info[:image_path] = @section_path + "/#{i}.story.pdf"
        elsif !@has_heading
          info[:image_path] = @section_path + "/#{i + 1}.story.pdf"
        end
        info[:x]          = grid_frame[0]*(@grid_width + @gutter) + @left_margin
        info[:y]          = grid_frame[1]*@grid_height  + @top_margin
        info[:width]      = grid_frame[2]*@grid_width + @gutter*(grid_frame[2] - 1)
        info[:height]     = grid_frame[3]*@grid_height
        info[:layout_expand] = nil
        info[:image_fit_type] = IMAGE_FIT_TYPE_HORIZONTAL
        # info[:image_fit_type] = IMAGE_FIT_TYPE_VIRTICAL
        @article_info << info.dup
      end
      @article_info
    end

    def create_story(story_index)
      story_path =  @section_path + "/#{story_index + 1}.story.md"
      if @has_heading
        @grid_frame = @grid_map[story_index+1]
      else
        @grid_frame = @grid_map[story_index]
      end 
      sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @grid_frame %>", @grid_frame.to_s)
      sample = sample.gsub("<%= @grid_width %>", @grid_width.to_s)
      sample = sample.gsub("<%= @grid_height %>", @grid_height.to_s)
      sample = sample.gsub("<%= @story_index %>", (story_index + 1).to_s)
      File.open(story_path, 'w'){|f| f.write sample}
    end
        
    def create
      system("mkdir -p #{@section_path}") unless File.exist?(@section_path)
      copy_heading_pdf if @has_heading
      @number_of_article.times do |i|
        create_story(i)
      end
      section_config_path = @section_path + "/config.yml"
      section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      section_rake_path = @section_path + "/Rakefile"
      File.open(section_rake_path, 'w'){|f| f.write SECTION_RAKE_FILE} unless File.exist?(section_rake_path)
    end

    
    def copy_heading_pdf
      @heading_sample = "/Users/Shared/SoftwareLab/news_heading/OurTimes/heading_#{@grid_key.split("x")[0]}.pdf"
      system("cp #{@heading_sample} #{@section_path}/heading.pdf") #unless File.exist?(@heading_sample)
    end
    
    def merge_article_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      #TODO update page fixtures
      @articles_info.each_with_index do |info, i|
	      Image.new(self, info)
	    end
	          
      if @output_path
        save_pdf(@output_path)
      else
        puts "No @output_path!!!"
      end
      self
    end

    def normalize_filenames
      new_names = []
      Dir.glob("#{@section_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @section_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end
end
