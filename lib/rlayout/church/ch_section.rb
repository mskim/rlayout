module RLayout

  class ChSection
    attr_reader :page_size, :width, :height
    attr_reader :section_path, :page_number
    attr_reader :pages, :pictures, :starting_offset, :image_column, :image_row

    def initialize(options={})
      @section_path = options[:section_path]
      @page_size = options[:page_size] || 'A5'
      @width   = SIZES[@page_size][0]
      @height  = SIZES[@page_size][1]
      @page_number = options[:page_number]
      @starting_offset = options[:starting_offset] || 0
      @image_column = options[:image_column] || 4
      @image_row = options[:image_row] || 5
      layout_members
      self
    end

    def layout_members
      @pages = []
      @pictures = Dir.glob("#{@section_path}/images/*.jpg")
      # shift by @starting_offset
      page_images = @pictures.each_slice(@image_column*@image_row).to_a
      # spilt @pictures array by page image_per_page
      page_images.each_with_index do |page_image, i|
        @pages << RLayout::ChPage.new(page_path: @section_path, width:@width, height:@height, page_image:page_image, image_column: @image_column, image_row: @image_row)
      end
    end

    def save_pdf(output_path, options={})
      # puts "genrateing pdf ruby "
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc  = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      # style_service.set_canvas_text_style(canvas, 'body')
      pages.each do |page|
        pdf_page    = @pdf_doc.pages.add([0, 0, @width, @height])
        canvas      = pdf_page.canvas
        page.draw_pdf(canvas)
      end
      @pdf_doc.write(output_path)
      ending_time = Time.now
      if options[:page_pdf]
        split_pdf(output_path)
      end
      puts "It took:#{ending_time - start_time}" if options[:time]
    end
  end
end