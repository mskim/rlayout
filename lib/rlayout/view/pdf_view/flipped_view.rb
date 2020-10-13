module RLayout

  class FilppedView
    attr_reader :graphic, :pdf_doc, :pdf_page

    def initialize(graphic, **options={})
      @graphic = graphic
      @pdf_doc  = HexaPDF::Document.new
      @pdf_page = @pdf_doc.pages.add([@graphic.x, @graphic.y, @graphic.width, @graphic.height])
      canvas    = @pdf_page.canvas
      draw
      save_pdf
      self
    end

    def draw

    end
    
    def save_pdf

    end

  end

end