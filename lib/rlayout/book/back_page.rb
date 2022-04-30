module RLayout
  # Page that starts the book.
  # With Title, subtitle, author, publisher_logo
  # Replica of front cover image
  # use RCover
  # 
  class BackPage < StyleablePage
    attr_reader :book_cover_folder, :document_path, :book_info, :pdf_page

    def initialize(options={})
      # binding.pry
      super
     
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

    def read_content
      if File.exist?(source_content_path)
        @content = YAML::load_file source_content_path
        # 
      else
        @content = default_content
        File.open(source_content_path, 'w'){|f| f.write default_content.to_yaml}
      end
    end
    

    def default_content
      h = {}
    end

    def default_layout_rb
      layout =<<~EOF
      RLayout::CoverPage.new(fill_color:'clear',width:#{@width}, height:#{@height}) do
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