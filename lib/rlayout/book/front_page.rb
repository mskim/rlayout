module RLayout
  class FrontPage < StyleablePage
    attr_reader :book_info

    def initialize(options={})
      @book_info = options[:book_info]
      super
      self
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def content_path
      @document_path + "/story.md"
    end

    def load_page_content
      if File.exist?(content_path)
        @page_content = YAML::load_file(content_path)
        File.open(content_path, 'r'){|f| f.read content_path}
      else
        @page_content = default_page_content
        File.open(content_path, 'w'){|f| f.write default_page_content}
      end
      @document.set_page_content
    end

    def default_page_content

      <<~EOF
      ---
      title : 홍길동
      profile_image: 1.jpg

      ---

      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.
      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.


      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.
      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.
      

      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.
      홍길동은 서자의 아들로 태어나 아버지를 아버라고 부르지 못하는 한을 안고 살아온 사람이다.book_info
      후세에 홍길동은 여러 책내용의 예재 저자 이름으로 사용 되고 있다.
      



      EOF
    end

    def cover_spread_pdf_path
      File.dirname(@document_path) + "/cover_spread/output.pdf"
    end

    def default_layout_rb
      layout =<<~EOF
      RLayout::CoverPage.new(fill_color:'clear',width:#{@width}, height:#{@height}) do
        image(image_path: '#{cover_spread_pdf_path}',  x: -#{@width}, y: 0,  width: #{@width}*2,  height: #{@height} )
        heading(1,0,4,10)
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