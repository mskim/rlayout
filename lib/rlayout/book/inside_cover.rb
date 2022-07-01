module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class InsideCover
    include Styleable
    attr_reader :cover_image_path
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_reader :title,  :subtitle, :author, :publisher
    def initialize(options={} ,&block)
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
      @title = options[:title]
      @subtitle = options[:subtitle]
      @author = options[:author]
      @publisher = options[:publisher]
      load_page_style
      # use image that was created for BookCover front_page image
      # @front_page_pdf = options[:front_page_pdf]
      # @document.add_image(@front_page_pdf) if @front_page_pdf
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg:@jpg)
      self
    end

    def page_count
      1
    end

    def default_layout_rb
      doc_options= {}
      doc_options[:width] = @width
      doc_options[:height] = @height
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      layout =<<~EOF
        RLayout::CoverPage.new(#{doc_options}) do
          heading(0,4,6,6)
        end
      EOF
    end

    def default_page_content
      <<~EOF
      ---
      heading:
        title : #{@title}
        subtitle : #{@subtitle}
        author : #{@author}

      ---
      
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

      EOF

    end
    

  end

end