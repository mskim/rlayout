module RLayout
  
  
  class NewspaperSectionPage < Page
    attr_accessor :section_path, :section_name, :output_path
    attr_accessor :has_heading, :heading_info, :paper_size
    attr_accessor :story_frames, :grid_key, :grid_width, :grid_height, :number_of_stories
    
    def initialize(options={}, &block)
      super
      @section_path   = options[:section_path] if options[:section_path]
      @output_path    = @section_path + "/section.pdf"
      @output_path    = options[:output_path]   if options[:output_path]  
      @paper_size     = options.fetch(:paper_size,"A2")
      @width          = SIZES[@paper_size][0]
      @height         = SIZES[@paper_size][1]
      @width          = options['width'] if options['width']
      @height         = options['height'] if options['height']
      @lines_in_grid  = options.fetch(:lines_in_grid, 10)
      @section_name   = options[:section_name] || "untitled"
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
      config_path     = @section_path + "/config.yml"
      if File.exist?(config_path)
        section_config = File.open(config_path, 'r'){|f| f.read}
        section_config = YAML::load(section_config)
        @section_name   = section_config['section_name'] || "untitled"
        @output_path    = section_config['output_path']   if section_config['output_path']      
        @width          = section_config['width'] if section_config['width']
        @height         = section_config['height'] if section_config['height']
        @gutter         = section_config['gutter'] if section_config['gutter']
        @v_gutter       = section_config['v_gutter'] if section_config['v_gutter']
        @left_margin    = section_config['left_margin'] if section_config['left_margin']
        @top_margin     = section_config['top_margin'] if section_config['top_margin']
        @right_margin   = section_config['right_margin'] if section_config['right_margin']
        @bottom_margin  = section_config['bottom_margin'] if section_config['bottom_margin']
        @grid_base      = section_config['grid_base'] if section_config['grid_base']
        @grid_base      = @grid_base.map {|e| e.to_i}
        @has_heading    = section_config['has_heading'] if section_config['has_heading']
        @grid_size      = section_config['grid_size']
        @grid_width     = @grid_size[0]
        @grid_height    = @grid_size[1]
        @grid_key       = section_config['grid_key'] if section_config['grid_key']
        @story_frames   = section_config['story_frames']
      end
      
      unless @story_frames
        #TODO used some precentive default story_frames
        puts "no @story_frames for #{@grid_key}!!!"
      end 
      @number_of_stories = @story_frames.length      
      self
    end
    
    def make_articles_info
      @article_info = []
      @story_frames.each_with_index do |grid_frame, i|
        info = {}
        if @has_heading == 1 && i == 0
          info[:image_path] = @section_path + "/heading.pdf"
        elsif @has_heading == 1 && i >= 0
          # info[:image_path] = @section_path + "/#{i}/output.pdf"
          info[:image_path] = @section_path + "/#{i}.story/output.pdf"
        elsif @has_heading == 0 #TODO false is represented as 0
          # info[:image_path] = @section_path + "/#{i + 1}/output.pdf"
          info[:image_path] = @section_path + "/#{i + 1}.story/output.pdf"
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
    
    def self.section_pdf(options)
      section_page = self.open(options)
      section_page.merge_article_pdf(options)
    end
    
    def self.open(options={})
      config_path     = options[:section_path] + "/config.yml"
      config          = File.open(config_path, 'r'){|f| f.read}
      section_options = YAML::load(config)
      section_options.merge!(options)
      NewspaperSectionPage.new(section_options)
    end
    
    def merge_article_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      #TODO update page fixtures
      make_articles_info.each_with_index do |info, i|
        info[:parent] = self
	      Image.new(info)
	    end
      if @output_path
        save_pdf(@output_path, options)
      else
        puts "No @output_path!!!"
      end
      self
    end
    
  end
  
end