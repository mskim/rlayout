module RLayout
  # Page that starts the book.
  # With Title, subtitle, author, publisher_logo
  # Replica of front cover image
  # use RCover
  # 
  class BackPage
    attr_reader :book_cover_folder, :document_path, :book_info, :pdf_page
    attr_reader :document_path, :info_text, :isbn_text
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    include Styleable
    def initialize(options={})
      @book_info = options[:book_info]
      options[:starting_page_side] = :left_side
      options[:page_type] = :column_text
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
      load_text_style
      load_layout_rb
      load_page_content    
      @document.save_pdf(@output_path, page_pdf: @page_pdf, jpg:@static_jpg_url)

      self
    end

    def page_count
      1
    end

    def source_content_path
      @book_cover_folder + "/#{style_klass_name}_content.yml"
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def load_page_content
      if File.exist?(content_path)
        @page_content = YAML::load_file(content_path)
      else
        @page_content = YAML::load(default_page_content)
        File.open(content_path, 'w'){|f| f.write default_page_content}
      end
      @document.set_page_content(@page_content)
    end


    # def read_content
    #   if File.exist?(source_content_path)
    #     @content = YAML::load_file source_content_path
    #     # 
    #   else
    #     @content = default_content
    #     File.open(source_content_path, 'w'){|f| f.write default_content.to_yaml}
    #   end
    # end

    def default_page_content
      <<~EOF
      ---
      heading:
      ---
      
      EOF

    end

    def cover_spread_pdf_path
      File.dirname(@document_path) + "/cover_spread/output.pdf"
    end

    def default_layout_rb
      <<~EOF
      RLayout::CoverPage.new(fill_color:'clear',width:#{@width}, height:#{@height}) do
        image(image_path: '#{cover_spread_pdf_path}',  x: -#{@width}, y: 0,  width: #{@width}*2,  height: #{@height} )
      end
      EOF
    end

    def default_text_style
      s=<<~EOF
      ---

      title:
        font: KoPubBatangPB
        font_size: 24.0
        text_alignment: center
        text_line_spacing: 10
        space_before: 100
      subtitle:
        font: KoPubDotumPL
        font_size: 18.0
        text_alignment: center
        text_line_spacing: 5
        space_before: 50
        space_after: 30
      author:
        font: KoPubDotumPL
        font_size: 14.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      running_head:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
        space_before: 1
      logo:
        from_bottom: 50
        width: 50
        height: 50
        position: 8
        image_path: local.pdf      
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
      EOF

    end
    
  end
end