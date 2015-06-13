# encoding: utf-8


#SECTION_RAKE_FILE is a single quoted heredoc to escape #{}
SECTION_RAKE_FILE = <<-'END'

task :default => 'section.pdf'

source_files = FileList["*.md", "*.markdown"]
task :pdf => source_files.ext(".pdf")
rule ".pdf" => ".md" do |t|
  sh "/Applications/newsman.app/Contents/MacOS/newsman story_pdf #{pwd}/#{t.source}"
end
rule ".pdf" => ".markdown" do |t|
  sh "/Applications/newsman.app/Contents/MacOS/newsman story_pdf #{pwd}/#{t.source}"
end

file 'section.pdf' => source_files.ext(".pdf") do |t|
  sh "/Applications/newsman.app/Contents/MacOS/newsman section_pdf #{pwd}"
end

END
#SECTION_RAKE_FILE is a single quoted heredoc to escape #{}


SAMPLE_NEWS_ARTICLE =<<EOF
---
title: 'This is a title for Story<%= @story_index %>'
author: 'Min Soo Kim'
---

This is where sample story text goes. Fill in this area with your story. This is where sample story text goes.
Fill in this area with your story.

This is the second paragraph. You could keep on writting until it fills up the box.

The box size is determined by grid_frame value at the top. It is usually looks somethink like grid_frame: [0,0,4,6]
The first value is x, y, width, height. So this the box will have size of 4 grid wide and 6 grid tall.

EOF

DEFAULT_SECTIONS = %w{Current Economy Entertainment Sports Culture Technology }
DEFAULT_SECTIONS2 = %w{current sports culture technology}

DEFAULT_NUMBER_OF_STORIES = [5,5,5,6,6,6]
SECTION_HTML =<<EOF
<h1>Visit Preview site! click the following lind</h1>
<a href="http://www.softwarelab.me/{{publication}}/{{issue}}/{{section}}/">Visit </a>

EOF

module RLayout

  class Newspaper
    attr_accessor :name, :publication_path, :sections
    attr_accessor :grid_base, :grid_width, :grid_height, :lines_in_grid, :gutter
    def initialize(options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @name         = options.fetch(:name,"OurTimes")
      @path         = options.fetch(:path, "/Users/Shared/Newspaper")
      @publication_path = "#{@path}/#{@name}"
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      @sections     = options.fetch(:sections, DEFAULT_SECTIONS.dup)
      @number_of_stories = options.fetch(:number_of_stories, DEFAULT_NUMBER_OF_STORIES.dup)
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
      info['number_of_stories']= @number_of_stories
      info['width']       = @width
      info['height']      = @height
      info['left_margin'] = @left_margin
      info['top_margin']  = @top_margin
      info['right_margin']= @right_margin
      info['bottom_margin']= @bottom_margin
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
          news_section = NewspaperSection.new(nil, :section_path=>section_path, :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i], :has_heading=>true)
        else
          news_section = NewspaperSection.new(nil, :section_path=>section_path,  :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i])
        end
        news_section.create_section
        news_section.update_section
      end
    end
    
  end

  # NewspaperSection is a sinlge page of a Newspaper
  # NewspaperSection are composed of many articles.
  # NewspaperSection can have one heading or none, depending on the setion type
  # Once the layout out of the section is set,
  # each article is layouted independently by the reporter who is working on the article.
  # each article is produced as PDF and mergerd with rest of the articles.
  # If section layout changes, each reporteds will have to adjust their articles to fit new new layout.

  class NewspaperSection < Page
    attr_accessor :section_path, :issue_numner, :date, :publication, :issue, :date, :section_name, :output_path
    attr_accessor :has_heading, :heading_info, :paper_size
    attr_accessor :heading_type #none, top, left_top_box,
    attr_accessor :section_config, :section_name, :articles_info, :story_frames, :grid_key, :grid_width, :grid_height, :number_of_stories

    def initialize(parent_graphic, options={}, &block)
      super
      @parent_graphic = parent_graphic
      @section_path   = options[:section_path] if options[:section_path]
      @section_name   = options[:section_name] || "untitled"
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
      @grid_base      = @grid_base.map {|e| e.to_i}
      @has_heading    = options[:has_heading] || false
      @number_of_stories = options.fetch(:number_of_stories, 5).to_i  
      @grid_width     = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height    = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      @grid_key       = "#{@grid_base.join("x")}"
      @grid_key      += "/H" if @has_heading
      @grid_key      += "/#{@number_of_stories}"
      @story_frames   = GRID_PATTERNS[@grid_key]
      unless @story_frames
        #TODO used some precentive default story_frames
        puts "no @story_frames for #{@grid_key}!!!"
      end 
      
      if options['grid_key']
        @grid_key     = options['grid_key'] 
        @story_frames = GRID_PATTERNS[@grid_key]
        @has_heading  = grid_key.split("/")[1]=~/^H/ ? true : false
        @number_of_stories = @story_frames.length      
      end
      @articles_info= make_articles_info
      if block
        instance_eval(&block)
      end
      self
    end
    
    def self.open(path, options={})
      config_path = path + "/config.yml"
      config      = File.open(config_path, 'r'){|f| f.read}
      options     = YAML::load(config)
      options[:section_path] = path
      NewspaperSection.new(nil, options)
    end
    
    # change grid_key value in cofig.yml
    def self.change_section_layout(path, grid_key)
      config_path = path + "/config.yml"
      section_config = File.open(config_path, 'r'){|f| f.read}
      section_config = YAML::load(section_config)
      section_config['grid_key'] = grid_key
      section_config['story_frames'] = @story_frames = GRID_PATTERNS[grid_key.to_sym]
      File.open(config_path, 'w'){|f| f.write section_config.to_yaml}
      section = self.open(path)
      section.update_section_layout
    end
    
    # Run rake to update pdf files in section folder
    def update_section
      system ("cd #{@section_path} && rake")
    end
    
    # grid_key has changed, so update section story files according to new layout
    # and regenerate all stroies to new layout
    # regenerate section.pdf and section.jpg
    def update_section_layout
      puts __method__
      unless GRID_PATTERNS[@grid_key]
        puts "There is no grid_key as #{grid_key}"
        return
      end
      @has_heading = @grid_key.split("/")[0] =~/H$/ ? true : false
      @story_frames = GRID_PATTERNS[@grid_key]
      # update config 
      section_config_path = @section_path + "/config.yml"
      section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      @number_of_stories.times do |i|
        story_path =  @section_path + "/#{i + 1}.story.md"
        if File.exist?(story_path)
          # Story.update_metadata(story_path, new_metadata)
        else
          # Need to create more story for new pattern
          sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @story_index %>", (story_index + 1).to_s)
          File.open(story_path, 'w'){|f| f.write sample}
        end
        # regenerate story
        options = {}
        options[:story_path]   = story_path
        ext = File.extname(story_path)
        options[:output_path]  = story_path.gsub(ext, ".pdf")
        options[:jpg]  = true
        NewsArticle.new(nil, options)
      end
      # update section pdf
      puts "generating section pdf..."
      merge_article_pdf(:jpg=>true)
      
    end
          	
    def make_section_config
      # Rubymotion YAML kit doesn't seem to work with symbols it reads symbols as ':key' String.
      # So, to make it work, I am saving keys  as String instead of symbol
      # It can play nicely since I could distinguish whether the options are coming from new or open
      # for  NewSection new, options keys are passed as symbols,
      # And for  NewSection open, options keys are stored as String, when reading from section config file.
      # YAML kit also haves true as 1 and false as 0
      # It reads 1. as 1.0 and 0 as 0.0, so be careful!!!!
      info ={}
      info['publication'] = @publication || "OurTimes"
      info['issue']       = @issue       || '100-100'
      info['date']        = @date         || '2015-4-5'
      info['section_name']= @section_name || "untitled"
      info['has_heading'] = @has_heading
      info['grid_key']    = @grid_key
      info['grid_size']   = [@grid_width, @grid_height]
      info['width']       = @width
      info['height']      = @height
      info['story_frames']= GRID_PATTERNS[@grid_key]
      info['left_margin']  = @left_margin
      info['right_margin'] = @right_margin
      info['top_margin']   = @top_margin
      info['bottom_margin']= @bottom_margin
      info['gutter']       = @gutter
      info
    end
    
    def make_articles_info
      @article_info = []
      @story_frames.each_with_index do |grid_frame, i|
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
        info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
        @article_info << info.dup
      end
      @article_info
    end

    def create_story(story_index)
      story_path =  @section_path + "/#{story_index + 1}.story.md"
      # if @has_heading
      #   @grid_frame = @story_frames[story_index+1]
      # else
      #   @grid_frame = @story_frames[story_index]
      # end 
      sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @story_index %>", (story_index + 1).to_s)
      File.open(story_path, 'w'){|f| f.write sample}
    end
        
    def create_section
      system("mkdir -p #{@section_path}") unless File.exist?(@section_path)
      copy_heading_pdf if @has_heading
      @number_of_stories.times do |i|
        create_story(i)
      end
      section_config_path = @section_path + "/config.yml"
      @section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      section_rake_path = @section_path + "/Rakefile"
      File.open(section_rake_path, 'w'){|f| f.write SECTION_RAKE_FILE} unless File.exist?(section_rake_path)
      system("mkdir -p #{@section_path + "/images"}")
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
        save_pdf(@output_path, options)
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
