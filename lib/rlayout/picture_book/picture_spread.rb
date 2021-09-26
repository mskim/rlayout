module RLayout

  class PictureSpread < RDocument

    attr_reader :document_path, :bg_image_path
    attr_reader :left_page_text_location, :right_page_text_location
    attr_accessor :page_size, :width, :height
    attr_accessor :pages, :starting_page
    attr_reader :left_margin, :top_margin, :right_margin, :bottom_margin, :gutter

    attr_reader :page_type, :toc_data
    def initialize(options={})
      @pages = []
      @page_size = options[:page_size] || 'A4'
      @width = SIZES[@page_size] [0]
      @height = SIZES[@page_size] [1]
      @document_path = options[:document_path]
      @pdf_path = @document_path + "/spread.pdf"
      @bg_image_path  = Dir.glob("#{@document_path}/*[.jpg,png]").first
      ext            = File.extname(@bg_image_path)
      @text_location_name    = File.basename(@bg_image_path, ext)
      @left_page_text_location = @text_location_name.split("_")[0]
      left_story_path = @document_path + "/1.txt"
      right_story_path = @document_path + "/2.txt"
      @story_left = File.open(left_story_path, 'r'){|f| f.read}
      @story_right = File.open(right_story_path, 'r'){|f| f.read}
      @right_page_text_location = @text_location_name.split("_")[1]
      add_pages
      save_pdf_with_ruby(@pdf_path, page_pdf:true)

      self
    end

    def add_pages
      PictureSpreadPage.new(parent: self, left_side:true, width:@width, height:@height, bg_image_path: @bg_image_path, text_location:@left_page_text_location, story: @story_left)
      PictureSpreadPage.new(parent: self, left_side:false, width:@width, height:@height, bg_image_path: @bg_image_path, text_location:@right_page_text_location, story: @story_right)
    end
  end


end