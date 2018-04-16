module RLayout


  class NewspaperSectionPage < Page
    attr_accessor :section_path, :section_name, :output_path
    attr_accessor :kind, :is_front_page, :paper_size, :page_heading
    attr_accessor :story_frames, :grid_width, :grid_height, :number_of_stories
    attr_accessor :body_line_height, :ad_type, :page_heading_margin_in_lines, :lines_per_grid, :draw_divider_line, :divider_line_thickness
    def initialize(options={}, &block)
      super

      @section_path   = options[:section_path] if options[:section_path]
      @output_path    = @section_path + "/section.pdf"
      @output_path    = options[:output_path]   if options[:output_path]
      @kind           = options.fetch(:kind,"article") # opinion, editorial
      @paper_size     = options.fetch(:paper_size,"A2")
      @width          = SIZES[@paper_size][0]
      @height         = SIZES[@paper_size][1]
      @grid_base      = options.fetch(:grid_base, [7, 12])
      @grid_base      = @grid_base.map {|e| e.to_i}
      @width          = options['width'] if options['width']
      @height         = options['height'] if options['height']
      @lines_in_grid  = options.fetch(:lines_in_grid, 7)
      @section_name   = options['section_name'] || "untitled"
      @gutter         = options.fetch('gutter', 10)
      @v_gutter       = options.fetch('v_gutter', 0)
      @left_margin    = options.fetch('left_margin', 50)
      @top_margin     = options.fetch('top_margin', 50)
      @right_margin   = options.fetch('right_margin', 50)
      @bottom_margin  = options.fetch('bottom_margin', 50)
      @is_front_page  = options['is_front_page'] || false
      @grid_size      = options.fetch('grid_size', [137.40142857142857, 96.94466666666668])
      @grid_width     = @grid_size[0]
      @grid_height    = @grid_size[1]
      # @grid_width     = (@width - @left_margin - @right_margin- (@grid_base[0]-1)*@gutter )/@grid_base[0]
      # @grid_height    = (@height - @top_margin - @bottom_margin)/@grid_base[1]
      @body_line_height = @grid_height/@lines_in_grid
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
        @ad_type        = section_config[:ad_type]
        @is_front_page  = section_config['is_front_page'] if section_config['is_front_page']
        @grid_size      = section_config['grid_size']
        @grid_width     = @grid_size[0]
        @grid_height    = @grid_size[1]
        @story_frames   = section_config['story_frames']
        @lines_per_grid = section_config['lines_per_grid'].to_i
        @page_heading_margin_in_lines = section_config['page_heading_margin_in_lines'].to_i
      end

      unless @story_frames
        #TODO used some precentive default story_frames
        puts "no @story_frames found!!!"
      end
      @number_of_stories = @story_frames.length
      @number_of_stories -= 1 if has_ad?
      self
    end

    def ad_image_path
      image_path = @section_path + "/ad/output.pdf"
      unless File.exist?(image_path)
        alternative_path = @section_path + "/ad/images"
        image_path = Dir.glob("#{alternative_path}/*[.jpg,.pdf]").first
      end
      puts "image_path:#{image_path}"
      image_path
    end

    # convert stopry frames into layout format
    def make_layout_info
      @layout_info = []
      @story_frames.each_with_index do |grid_frame, i|
        info = {}
        found_ad = false
        if grid_frame.length == 5 && grid_frame[4] =~/^광고/
          # found_ad = grid_frame[4][:광고] || grid_frame[4]['광고'] || grid_frame[4][:'광고'] || grid_frame[4]['광고']
          info[:image_path] = ad_image_path
        else
          info[:image_path] = @section_path + "/#{i + 1}/story.pdf"
        end

        # info[:x] = grid_frame[0]*(@grid_width + @gutter) + @left_margin
        info[:x]              = grid_frame[0]*@grid_width + @left_margin
        info[:y]              = grid_frame[1]*@grid_height + @top_margin
        info[:width]          = grid_frame[2]*@grid_width
        info[:height]         = grid_frame[3]*@grid_height

        if grid_frame.last =~/^extend/
          @extened_line_count = grid_frame.last.split("_")[1].to_i
          info[:height] += @body_line_height*@extened_line_count
        end

        info[:layout_expand]  = nil
        info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
        # info[:image_fit_type] = IMAGE_FIT_TYPE_ORIGINAL
        @layout_info << info.dup
      end
      @layout_info
    end

    def self.section_pdf(options)
      section_page = self.open(options)
      section_page.merge_layout_pdf(options)
    end

    def self.open(options={})
      config_path     = options[:section_path] + "/config.yml"
      config          = File.open(config_path, 'r'){|f| f.read}
      section_options = YAML::load(config)
      section_options.merge!(options)
      NewspaperSectionPage.new(section_options)
    end

    def has_ad?
      @ad_type && @ad_type !='no_ad'
    end

    def merge_layout_pdf(options={})
      @output_path = options[:output_path] if options[:output_path]
      #TODO update page fixtures
      # make_page_heading_image
      make_layout_info.reverse.each_with_index do |info, i|
        info[:parent] = self
        # info[:stroke_width] = 1
	      Image.new(info)
	    end
      # page heading
      heading_info = {}
      heading_info[:parent] = self
      heading_info[:image_path] = @section_path + "/heading/layout.pdf"
      heading_info[:x]          = @left_margin
      heading_info[:y]          = @top_margin
      heading_info[:width]      = @width - @left_margin - @right_margin
      heading_info[:layout_expand]  = nil
      heading_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
      # heading_info[:image_fit_type] = IMAGE_FIT_TYPE_ORIGINAL

      if @is_front_page
        #TODO
        # NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES     = 1
        # NEWS_ARTICLE_HEADING_SPACE_IN_LINES                      = 3
        heading_info[:height]   = (@lines_per_grid + @page_heading_margin_in_lines) * @body_line_height
      else
        heading_info[:height]   = @page_heading_margin_in_lines * @body_line_height
      end

      @page_heading = Image.new(heading_info)

      if @output_path
        save_pdf(@output_path, options)
      else
        puts "No @output_path!!!"
      end

      self
    end

  end

end
