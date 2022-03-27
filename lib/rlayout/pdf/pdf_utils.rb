module RLayout


  # PdfUtils provides pdf_doc, a pdf document that we can draw and save pdf document
  #
  # PdfUtils also  provides token width of a string with text_style
  # 
  class PdfUtils
    attr_reader :pdf_doc, :page, :canvas
    attr_accessor :pdf_path, :jpg
    attr_reader :width, :height
    attr_reader :style_service
    attr_reader :current_style_name
  
    def initialize(width, height, options={})
      @width    = width
      @height   = height
      @pdf_path = options[:pdf_path]
      @pdf_doc  = HexaPDF::Document.new
      @page     = @pdf_doc.pages.add([0, 0, @width, @height])
      @canvas   = @page.canvas
      @style_service = RLayout::StyleService.shared_style_service
      if options[:text_style]
        # set @style_service with given coustom text_style as current text_style
      end
      @style_service.pdf_doc = @pdf_doc
      self
    end

    def add_page
      @pdf_doc.pages.add([@x, @y, @width, @height])
      @page = @pdf_doc.pages.last
      @canvase = @page.canvas
    end
  end



end
