# encoding: utf-8


#SECTION_RAKE_FILE is a single quoted heredoc to escape #{}
SECTION_RAKE_FILE = <<-'EOF'
  task :default => 'section.pdf'
  source_files = FileList["**/*.md", "**/*.markdown"]

  task :pdf => source_files.ext(".pdf")
  rule ".pdf" => ".md" do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman news_article #{pwd}/#{File.dirname(t.source)}"
  end
  rule ".pdf" => ".markdown" do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman news_article #{pwd}/#{File.dirname(t.source)}"
  end

  file 'section.pdf' => source_files.ext(".pdf") do |t|
    sh "/Applications/newsman.app/Contents/MacOS/newsman section_pdf #{pwd}"
  end

  EOF
#SECTION_RAKE_FILE is a single quoted heredoc to escape #{}

SAMPLE_ARTICLE_LATOUT = <<-EOF

RLayout::NewsArticleBox.new(nil, <%= @story_options %>) do
  heading
<%= @image_text %>
#  float_image(:local_image=>"1.jpg", :grid_frame=>[0,0,1,1])
#  float_image(:local_image=>"2.jpg", :grid_frame=>[1,0,1,1])
end

EOF

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
    attr_accessor :publication_path, :issue_date, :issue_number, :issue_path
    def initialize(publication_path, options={})
      @publication_path = publication_path
      @issue_date  = options.fetch(:issue_date, "2015-4-5")
      @issue_path = @publication_path + "/" + @issue_date
      create_sections
      self
    end
    
    def publication_name
      File.basename(@publication_path)
    end
    
    def create_sections
      publication_config = File.open(@publication_path + "/config.yml", 'r'){|f| f.read}
      @publication_info = YAML::load(publication_config)
      @publication_info['sections'].each_with_index do |section_name, i|
        section_path = @issue_path + "/#{section_name}"
        output_path = section_path + "/section.pdf"
        if i== 0
          news_section = NewspaperSection.new(self, :section_path=>section_path, :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i], :has_heading=>true)
        else
          news_section = NewspaperSection.new(self, :section_path=>section_path,  :section_name=>section_name, :output_path=> output_path, :number_of_stories=>@publication_info['number_of_stories'][i])
        end
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

  class NewspaperSection
    attr_accessor :issue, :section_path, :issue_numner, :date, :publication, :issue, :section_name, :output_path
    attr_accessor :has_heading, :paper_size
    attr_accessor :section_config, :articles_info, :story_frames, :grid_key, :grid_width, :grid_height, :number_of_stories

    def initialize(issue, options={}, &block)
      @issue          = issue
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
      end
      system("mkdir -p #{@section_path}") unless File.exist?(@section_path)
      copy_heading_pdf if @has_heading
      section_config_path = @section_path + "/config.yml"
      @section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write @section_config.to_yaml}
      section_rake_path = @section_path + "/Rakefile"
      File.open(section_rake_path, 'w'){|f| f.write SECTION_RAKE_FILE} unless File.exist?(section_rake_path)
      system("mkdir -p #{@section_path + "/images"}")
      @number_of_stories = @story_frames.length      
      
      if @has_heading
        @number_of_stories -= 1
      end
      @number_of_stories.times do |i|
          create_story(i)
          make_story_layout(i)        
      end
      
      self
    end
    
    def create_story(story_index)
      story_project_path =  @section_path + "/#{story_index + 1}"
      system("mkdir #{story_project_path}") unless File.directory?(story_project_path)
      story_path =  story_project_path + "/story.md"
      sample = SAMPLE_NEWS_ARTICLE.gsub("<%= @story_index %>", (story_index + 1).to_s)
      File.open(story_path, 'w'){|f| f.write sample}
      images_path = story_project_path + "/images"
      system("mkdir #{images_path}") unless File.directory?(images_path)
    end
    
    def make_story_layout(story_index)
      article_path  = @section_path + "/#{story_index + 1}"
      images        = Dir.glob("#{article_path}/images/*.{jpg,pdf,tiff}")
      layout_index  = story_index
      layout_index  = story_index + 1 if @has_heading
      @story_options= make_story_options(layout_index)
      puts "@story_options:#{@story_options}"
      puts "++++++++ images:#{images}"
      # make image text
      @image_text   = ""
      images.each_with_index do |image, i|
        @image_text += "  float_image(:local_image=>\"#{File.basename(image)}\", :grid_frame=>[0,#{i},1,1])\n"
      end
      # TODO 
      # If I read template then save, I am getting error writing file.
      # Char Count is saved instead of String????
      # template_path     = "/Users/Shared/SoftwareLab/article_template/news_article.rb.erb"
      # unless File.exist?(template_path)
      #   puts "no template_path #{template_path} found !!!"
      #   return
      # end
      # template_text = File.open(template_path, 'r'){|f| f.read}
      # puts "template_text:#{template_text}"
      layout_path   = article_path + "/layout.rb"
      erb           = ERB.new(SAMPLE_ARTICLE_LATOUT)
      File.open(layout_path, 'w'){|f| f.write erb.result(binding)}
    end 
    
    def make_section_config
      # Each section folderd keeps a file called config.yml.
      # config.yml has information about the section.
      # Rubymotion YAML kit doesn't seem to work with symbols it reads symbols as ':key' String.
      # So, to make it work, I am saving keys  as String instead of symbol
      # It can play nicely since I could distinguish whether the options are coming from new or open
      # for  NewspaperSection new, options keys are passed as symbols,
      # And for  NewspaperSection open, options keys are stored as String, when reading from section config file.
      # YAML kit also haves true as 1 and false as 0
      # It reads 1. as 1.0 and 0 as 0.0, so be careful!!!! need to convert it to_i after reading.
      info ={}
      info['publication'] = @issue.publication_name || "OurTimes"
      info['issue']       = @issue.issue_number       || '100-100'
      info['date']        = @issue.issue_date         || '2015-4-5'
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
    
    # change grid_key value in cofig.yml
    def change_section_layout(path, grid_key)
      config_path = path + "/config.yml"
      section_config = File.open(config_path, 'r'){|f| f.read}
      section_config = YAML::load(section_config)
      @section_config['grid_key'] = grid_key
      @section_config['story_frames'] = @story_frames = GRID_PATTERNS[grid_key.to_sym]
      File.open(config_path, 'w'){|f| f.write @section_config.to_yaml}
      section.update_section_layout
    end
    
    
    # grid_key has changed, so update section story files according to new layout
    # and regenerate all stroies to new layout
    # regenerate section.pdf and section.jpg
    def update_section_layout
      unless GRID_PATTERNS[@grid_key]
        puts "There is no grid_key as #{grid_key}"
        return
      end
      @has_heading = @grid_key.split("/")[0] =~/H$/ ? true : false
      @story_frames = GRID_PATTERNS[@grid_key]
      @number_of_stories = @story_frames.length
      # update config 
      section_config_path = @section_path + "/config.yml"
      section_config = make_section_config
      File.open(section_config_path, 'w'){|f| f.write section_config.to_yaml}
      if @has_heading
        @number_of_stories -= 1
      end
      @number_of_stories.times do |i|
        story_path =  @section_path + "/#{i + 1}.story.md"
        if File.exist?(story_path)
          make_story_layout(i)
        else
          # Need to create more story for new pattern
          create_story(i)
          make_story_layout(i)
        end
      end
      # update section pdf
      puts "generating section pdf..."
      update_section
    end
    
    # Run rake to update pdf files in section folder
    def update_section
      system ("cd #{@section_path} && rake")
    end
          	    
    def make_story_options(story_index)
      story_frame_index = story_index.to_i      
      options = {}
      options[:grid_frame]         = @section_config['story_frames'][story_frame_index]
      options[:grid_frame]         = eval(options[:grid_frame]) if options[:grid_frame].class == String
      options[:grid_frame]         = options[:grid_frame].map {|e| e.to_i}
      options[:gutter]             = @section_config['gutter'] || 10
      options[:v_gutter]           = @section_config['gutter'] || 0
      options[:column_count]       = options[:grid_frame][2]
      options[:grid_width]         = @section_config['grid_size'][0]
      options[:grid_height]        = @section_config['grid_size'][1]
      options[:width]              = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
      options[:height]             = options[:grid_height] * options[:grid_frame][3]+ (options[:grid_frame][3] - 1)*options[:v_gutter]
      options
    end
    
    def read_story_config(section_config_path, story_index)
        config = YAML::load(File.open(section_config_path, 'r'){|f| f.read})
        # YamlKit in Rubymotion saves true as 1 and reads as 1.0
        story_frame_index = story_index.to_i
        if config['has_heading'] == true || config['has_heading'] == 1.0
          story_frame_index += 1
        end
        options = {}
        options[:grid_frame]         = config['story_frames'][story_frame_index]
        options[:grid_frame]         = eval(options[:grid_frame]) if options[:grid_frame].class == String
        puts "options:#{options}"
        puts "options[:grid_frame]:#{options[:grid_frame]}"
        options[:grid_frame]         = options[:grid_frame].map {|e| e.to_i}
        options[:grid_base]          = [options[:grid_frame][2],options[:grid_frame][3]]
        options[:gutter]             = config['gutter'] || 10
        options[:v_gutter]           = config['gutter'] || 0
        options[:column_count]       = options[:grid_frame][2]
        options[:grid_width]         = config['grid_size'][0]
        options[:grid_height]        = config['grid_size'][1]
        options[:x]                  = 0
        options[:y]                  = 0
        options[:width]              = options[:grid_width] * options[:grid_frame][2] + (options[:grid_frame][2] - 1)*options[:gutter]
        options[:height]             = options[:grid_height] * options[:grid_frame][3]+ (options[:grid_frame][3] - 1)*options[:v_gutter]
        options      
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
