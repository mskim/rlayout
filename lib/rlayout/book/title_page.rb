module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class TitlePage
    include Styleable
    attr_reader :document_path
    attr_reader :title, :subtitle, :author
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    def initialize(options={} ,&block)
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @output_path = @document_path + "/output.pdf"
      @starting_page_number = options[:starting_page_number] || 1
      @title = options[:title]
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin] 
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @page_pdf = options[:page_pdf] || true
      @book_title  = options[:book_title]
      @jpg = options[:jpg] || false
      load_page_style  
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg:@jpg)
      self
    end

    def default_page_content
      <<~EOF
      ---
      heading:
        title : #{@title}

      ---
      
      EOF

    end

    def page_count
      1
    end

    def default_layout_rb
      binding.pry
      doc_options= {}
      # doc_options[:paper_size] = @paper_size
      doc_options[:width] = @width
      doc_options[:height] = @height
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      layout =<<~EOF
        RLayout::CoverPage.new(#{doc_options}) do
          heading(1,1,4,6)
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
      body_gothic:
        font: KoPubBatangPM
        font_size: 11.0
        text_alignment: justify
        first_line_indent: 11.0
      title:
        font: KoPubBatangPB
        font_size: 16.0
        text_alignment: center
        text_line_spacing: 10
        space_before: 0
      subtitle:
        font: KoPubDotumPL
        font_size: 12.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      author:
        font: KoPubDotumPL
        font_size: 10.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      running_head:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "##"
        text_alignment: left
        space_before: 1
      running_head_2:
        font: KoPubDotumPL
        font_size: 11.0
        markup: "###"
        text_alignment: middle
        space_before: 1
      quote:
        font: KoPubDotumPL
        font_size: 11.0
        markup: "####"
        text_alignment: left
        left_indext: 100
        right_indext: 100
        space_before: 1
      header:
        font: KoPubBatangPM
        font_size: 7.0      
      footer:
        font: KoPubBatangPM
        font_size: 7.0
      caption_title:
        korean_name: 사진제목
        category:
        font_family: KoPub돋움체_Pro Bold
        font: KoPubDotumPB
        font_size: 9.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.2
      caption:
        korean_name: 사진설명
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.5
      source:
        korean_name: 사진출처
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: right
        tracking: -0.2
      footnote:
        font: Shinmoon
        font_size: 8.0
        text_alignment: left
        text_color: red
        first_line_indent: 11.0
      EOF

    end
    
  end

end