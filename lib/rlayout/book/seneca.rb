module RLayout

  class Seneca < StyleablePage
    attr_reader :content, :updated

    # Seneca direction can be horizontal or vertical
    attr_reader :direction

    def initialize(options={}, &block)
      @document_path = options[:document_path]
      super
      self
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def content_path
      @document_path + "/content.yml"
    end

    def load_layout_rb
      if File.exist?(layout_rb_path)
        @layout_rb = File.open(layout_rb_path, 'r'){|f| f.read}
      else
        @layout_rb = default_layout_rb
        File.open(layout_rb_path, 'w'){|f| f.write default_layout_rb}
      end
    end
    
    def default_content
      h = {}
      h[:title] = "소설을 쓰고 있네"
      h[:subtitle] = "정말로 소설을 쓰고 있네 그려"
      h[:author] = "홍길동"
      h[:publisher] = "활빈당출판"
      h
    end

    def default_layout_rb
      # text(tag: 'title', font_size: 16, text_alignment: 'center', layout_length:2, fill_color: 'white')
      # text(tag: 'subtitle', font_size: 10, text_alignment: 'center', layout_length:2)
      # text(tag: 'author', font_size: 12)
      # text(tag:  'publisher', font_size: 9)
      # relayout!
      <<~EOF
      RLayout::CoverPage.new(fill_color:'clear', width:#{@width}, height:#{@height}) do
        seneca_h(0, 0, #{@width}, #{@height})
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
        font_size: 20.0
        text_alignment: left
        text_line_spacing: 10
        space_before: 0
      subtitle:
        font: KoPubDotumPL
        font_size: 16.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      author:
        font: KoPubDotumPL
        font_size: 14.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30

      EOF

    end

  end

end