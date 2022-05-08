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

    def load_page_content
      if File.exist?(content_path)
        @page_content = YAML::load_file(content_path)
      else
        @page_content = YAML::load(default_page_content)
        File.open(content_path, 'w'){|f| f.write default_page_content}
      end
      @document.set_page_content(@page_content)
    end

    def default_page_content
      <<~EOF
      ---
      seneca:
        title: 여기는 책제목
        subtitle: 여기는 부제목
        author: 홍길동
        publisher: 할빈동

      EOF
    end

    def default_layout_rb
      <<~EOF
      RLayout::CoverPage.new(fill_color:'clear', width:#{@width}, height:#{@height}, margin: 0) do
        seneca_h(0, 0, 6, 12)
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