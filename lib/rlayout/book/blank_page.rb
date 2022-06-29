module RLayout

  class BlankPage
    attr_reader :page_count, :document_path
    attr_reader :style_guide_folder
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_reader :document
    attr_reader :page_pdf
    attr_reader :starting_page_number
    attr_reader :output_path, :jpg

    def initialize(options={})
      @document_path = options[:document_path]
      @width =  options[:width]
      @height =  options[:height]
      @page_count = options[:page_count] || 1
      @page_pdf = options[:page_pdf] || true
      @jpg = options[:jpg] || false
      @output_path = @document_path + "/output.pdf"
      @document = eval(default_layout_rb)
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg:@jpg)
    end

    def default_layout_rb
      layout =<<~EOF
        RLayout::RDocument.new(width:#{@width}, height:#{@height}, page_count:#{@page_count})
      EOF

    end

    def default_header_footer_yml
      <<~EOF
      ---
      has_hearder: false
      has_footer: false
      ---

      EOF
    end

  end



end