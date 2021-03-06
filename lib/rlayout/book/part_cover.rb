module RLayout

  # TODO
  # hande two page part_cover
  class PartCover
    attr_reader :book, :title, :order, :page_count
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    include Styleable
    def initialize(options={})
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @output_path = @document_path + "/output.pdf"
      @starting_page_number = options[:starting_page_number] || 1
      @page_pdf = options[:page_pdf] || true
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin] 
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @jpg = options[:jpg] || false
      @page_count = options[:page_count] || 1
      @title = options[:title] || 'The Name of the Part'
      @order = options[:order] || '01'
      @order = options[:order] || '01'
      @document.set_page_content(part_cover_data)
      @document.save_pdf(output_path, page_pdf:true, jpg:true)
      save_toc
    end

    def part_cover_data
      heading = {}
      heading[:part_order] = "PART_#{order}"
      heading[:title] = @title
      h = {}
      h[:heading] = heading
      h
    end

    def output_path
      @document_path + "/chapter.pdf"
    end

    def layout_options
      h = {}
      h[:document_path] = @document_path  
      h[:width] = @width
      h[:height] = @height
      # h[:fill_color] = 'blue'
      h[:fill_color] = 'clear'
      h[:toc]        = true
      h
    end

    def filler_page_layout
      <<~EOF
      RLayout::CoverPage.new(fill_color:'clear', width:#{layout_options}) do
      end
      EOF
    end

    def default_layout_rb
      <<~EOF
      RLayout::CoverPage.new(#{layout_options}) do
        heading(1,4,3,4)
      end
      EOF
    end

    def default_text_style
      s=<<~EOF
      ---
      body:
        font: Shinmoon
        font_size: 11.0
        text_alignment: justify
        first_line_indent: 11.0
      title:
        font: KoPubBatangPB
        font_size: 16.0
        text_color: 'red'
        text_alignment: right
        text_line_spacing: 10
        space_before: 0
      subtitle:
        font: KoPubDotumPL
        font_size: 12.0
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      part_order:
        font: KoPubDotumPL
        font_size: 12.0
        text_color: 'red'
        text_alignment: right
        text_line_spacing: 5
        space_after: 10
      author:
        font: KoPubDotumPL
        font_size: 10.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30      
      EOF

    end
    
    def save_toc
      toc_path = @document_path + "/toc.yml"
      @toc_content = []
      toc_item = {}
      toc_item[:page] = @starting_page_number
      toc_item[:markup] = 'h1'
      toc_item[:para_string] = @title
      @toc_content << toc_item
      File.open(toc_path, 'w') { |f| f.write @toc_content.to_yaml}
    end
  end

end