module RLayout

  class ChIndex
    attr_reader :page_size, :width, :height
    attr_reader :index_path, :member_index_csv_path
    attr_reader :pages, :pictures, :image_column, :image_row

    def initialize(options={})
      @index_path = options[:index_path]
      @member_index_csv_path = @index_path + "/member_index.csv"
      @page_size = options[:page_size] || 'A5'
      @width   = SIZES[@page_size][0]
      @height  = SIZES[@page_size][1]
      @page_number = options[:page_number]
      @list_column = options[:list_column] || 1
      @body_line_count = options[:body_line_count] || 30
      layout_members
      self
    end

    def layout_members
      @pages = []
      @member_csv = File.open(@member_index_csv_path, 'r'){|f| f.read}
      csv = CSV.parse(@member_csv)
      head_row = csv.shift
      members_per_page = csv.to_a.each_slice(@list_column*@body_line_count).to_a
      # spilt @pictures array by page image_per_page
      members_per_page.each_with_index do |page_member, i|
        page_member.unshift(head_row)
        @pages << RLayout::ChIndexPage.new(page_path: @index_path, width:@width, height:@height, page_members:page_member, list_column: @list_column, body_line_count: @body_line_count)
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