# encoding: utf-8
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
title: 'This is a title for Story<%= @story_index %>'
grid_frame: <%= @grid_frame %>
grid_size: [<%= @grid_width %>, <%= @grid_height %>]

author: 'Min Soo Kim'
---

This is where sample stroy text goes. Fill in this area with your story. This is where sample stroy text goes.
Fill in this area with your story.

This is the second paragraph. You could keep on writting until it fills up the box.

The box size is determined by grid_frame value at the top. It is usually looks somethink like grid_frame: [0,0,4,6]
The first value is x, y, width, height. So this the box will have size of 4 grid wide and 6 grid tall.


EOF


module RLayout

  class Newspaper
    attr_accessor :publication_path, :front_matter, :body_matter, :rear_matter
    attr_accessor :publication_info, :grid_base, :grid_width, :grid_height, :lines_in_grid, :gutter
    def initialize(publication_path, options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @publication_path = publication_path
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
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
      if block
        instance_eval(&block)
      end
      self
    end

    def publication_info
      {
        width:          @width,
        height:         @height,
        left_margin:    @left_margin,
        top_margin:     @top_margin,
        right_margin:   @right_margin,
        botoom_margin:  @bottom_margin,
        grid_base:      @grid_base,
        grid_width:     @grid_width,
        grid_height:    @grid_height,
        gutter:         @gutter,
        v_gutter:       @v_gutter,
        lines_in_grid:  @lines_in_grid,
      }
    end

    def page_lines
      @lines_in_grid * @grid_base[1]
    end

    def line_height
      (@height - @top_margin - @bottom_margin)/page_lines
    end

  end



  class NewspaperIssue
    attr_accessor :publication
    attr_accessor :issue_path, :issue_number, :issue_date
    def initialize(publication, options={})
      @publication = publication
      @issue_date  = options.fetch(:issue_date, Time.now)
      set_up
      self
    end

    def set_up
      # system("mkdir -p #{issue_path}") unless File.exists?(issue_path)
      create_sections
    end

    def create_sections

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
    attr_accessor :section_path, :issue_numner, :date, :section_name, :output_path
    attr_accessor :has_heading, :heading_info, :paper_size
    attr_accessor :heading_type #none, top, left_top_box,
    attr_accessor :articles_info, :grid_map, :grid_key

    def initialize(parent_graphic, options={}, &block)
      puts "init of NewspaperSection"
      puts "options:#{options}"
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
      @grid_base      = [7, 11] if @has_heading
      @heading_info   = options.fetch(:heading_info, {:layout_length=>1})
      @number_of_article = options.fetch(:number_of_article, 5)
      @grid_width     = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      @grid_height    = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      @grid_key       = "#{@grid_base.join("x")}/#{@number_of_article}"
      puts GRID_PATTERNS["#{@grid_key}/#{@number_of_article}"]
      @grid_map       = GRID_PATTERNS["#{@grid_key}"]
      if options['grid_key']
        @grid_key     = options['grid_key'] 
        @grid_map     = GRID_PATTERNS["#{@grid_key}"]
      end
      puts "@grid_base:#{@grid_base}"
      puts "@grid_key:#{@grid_key}"
      puts "@grid_map:#{@grid_map}"
      
      @articles_info= make_articles_info
      @articles_info= options[:articles_info] if options[:articles_info]
      if @has_heading
        @top_margin += @grid_height
      end
      if block
        instance_eval(&block)
      end
      self
    end
    
    def self.open(path)
      config_path = path + "/config.yml"
      config = File.open(config_path, 'r'){|f| f.read}
      puts options = YAML::load(config)
      #TODO one liner?
      # options = options.keys.each do |key, value|
      #   symbolized_options[key.to_sym] = value
      # end
      # puts symbolized_options
      options[:section_path] = path
      NewspaperSection.new(nil, options)
    end
    
    def make_section_info
      # Rubymotion YAML kit doesn't seem to work with symbols
      # So, to make it consistant, I am using the key as strings instead of symbols
      info ={}
      info['section_name'] = @section_name || "untitled"
      info['has_heading']  = @has_heading
      info['grid_key']     = @grid_key
      info['width']        = @width
      info['height']       = @height
      # info[:left_margin]  = @left_margin
      # info[:right_margin] = @right_margin
      # info[:top_margin]   = @top_margin
      # info[:bottom_margin]= @bottom_margin
      # info[:gutter]       = @gutter
      info
    end
    
    def make_articles_info
      puts __method__
      @article_info = []
      puts "@grid_map:#{@grid_map}"
      @number_of_article.times do |i|
        puts "++++i#{i}:#{@grid_map[i]}"
        info = {}
        info[:image_path] = @section_path + "/#{i + 1}.story.pdf"
        info[:x]          = @grid_map[i][0]*(@grid_width + @gutter) + @left_margin
        info[:y]          = @grid_map[i][1]*@grid_height  + @top_margin
        info[:width]      = @grid_map[i][2]*@grid_width + @gutter*(@grid_map[i][2] - 1)
        info[:height]     = @grid_map[i][3]*@grid_height
        info[:layout_expand] = nil
        info[:image_fit_type] = IMAGE_FIT_TYPE_HORIZONTAL
        # info[:image_fit_type] = IMAGE_FIT_TYPE_VIRTICAL
        @article_info << info.dup
      end
      @article_info
    end

    def create
      system("mkdir -p #{@section_path}") unless File.exist?(@section_path)
      puts "creating story"
      @number_of_article.times do |i|
        path = @section_path + "/#{i + 1}.story.md"
        puts "++++i#{i}:#{@grid_map[i]}"
        @grid_frame = @grid_map[i]
        sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @grid_frame %>", @grid_frame.to_s)
        sample = sample.gsub("<%= @story_index %>", (i+1).to_s)
        sample = sample.gsub("<%= @grid_width %>", @grid_width.to_s)
        sample = sample.gsub("<%= @grid_height %>", @grid_height.to_s)
        File.open(path, 'w'){|f| f.write sample}
      end
      section_path = @section_path + "/config.yml"
      section_info = make_section_info
      File.open(section_path, 'w'){|f| f.write section_info.to_yaml}
      rake_path = @section_path + "/Rakefile"
      File.open(rake_path, 'w'){|f| f.write SAMPLE_RAKEFILR} unless File.exist?(rake_path)
    end

    def make_html

    end
    
    def place_heading
      
    end
    
    def merge_article_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      if @has_heading
        place_heading
      end
      @articles_info.each do |info|
        puts "info:#{info}"
        # article_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
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
