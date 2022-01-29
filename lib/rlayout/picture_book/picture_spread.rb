module RLayout

  class PictureSpread < RDocument

    attr_reader :spread_path, :project_path, :bg_image_path
    attr_reader :left_page_text_location, :right_page_text_location
    attr_accessor :page_size, :width, :height
    attr_accessor :pages, :starting_page_number
    attr_reader :left_margin, :top_margin, :right_margin, :bottom_margin, :gutter
    attr_reader :page_type, :toc_data
    attr_reader :spread_image_path, :left_page_image_path, :right_page_image_path
    attr_reader :left_side_stories, :right_side_stories
    def initialize(spread_path, options={})
      @spread_path = spread_path
      @pages = []
      @page_size = options[:page_size] || 'A4'
      @width = SIZES[@page_size] [0]
      @height = SIZES[@page_size] [1]
      @project_path = File.dirname(@spread_path)
      @build_path = @project_path + "/_build"
      @build_spread_path = options[:build_spread_path] || @build_path + "/#{File.basename(@spread_path)}"
      @pdf_path = @build_spread_path + "/spread.pdf"
      # bg_image_path  = Dir.glob("#{@spread_path}/*[.jpg,.png,.tiff]").first
      # ext            = File.extname(@bg_image_path)
      # @text_location_name    = File.basename(@bg_image_path, ext)
      # @left_page_text_location = @text_location_name.split("_")[0]
      @folder_images  = Dir.glob("#{@spread_path}/*{.jpg,.png,.tiff}")
      if @folder_images.length == 1
        @spread_image_path = @folder_images.first
      else
        @left_page_image_path = @folder_images.first
        @right_page_image_path = @folder_images.first
      end
      @folder_stories  = Dir.glob("#{@spread_path}/*[.txt,.md]")
      @left_side_stories = []
      @right_side_stories = []
      @folder_stories.each do |story|
        if File.basename(story) =~/^1/
          @left_side_stories << story
        elsif File.basename(story) =~/^2/
          @right_side_stories << story
        end
      end
      # left_story_path = @spread_path + "/1.txt"
      # right_story_path = @spread_path + "/2.txt"
      # @story_left = File.open(left_story_path, 'r'){|f| f.read}
      # @story_right = File.open(right_story_path, 'r'){|f| f.read}
      # @right_page_text_location = @text_location_name.split("_")[1]
      add_pages
      FileUtils.mkdir_p(@build_spread_path) unless File.exist?(@build_spread_path)
      save_pdf_with_ruby(@pdf_path, page_pdf:true)
      self
    end

    def source_spread_path
      @spread_path
    end

    def add_pages
      # PictureSpreadPage.new(parent: self, left_side:true, width:@width, height:@height, bg_image_path: @bg_image_path, text_location:@left_page_text_location, story: @story_left)
      if @spread_image_path
        PictureSpreadPage.new(parent: self, left_side:true, width:@width, height:@height, spread_image_path: @spread_image_path, stories: @left_side_stories)
        PictureSpreadPage.new(parent: self, left_side:false, width:@width, height:@height, spread_image_path: @spread_image_path, stories: @right_side_stories)
      else
        PictureSpreadPage.new(parent: self, left_side:true, width:@width, height:@height, page_image_path: @left_page_image_path, stories: @left_side_stories)
        PictureSpreadPage.new(parent: self, left_side:false, width:@width, height:@height, page_image_path: @right_page_image_path, stories: @right_side_stories)
      end
    
    end
  end


end