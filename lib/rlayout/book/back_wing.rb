module RLayout


  # The goal of BackWing is to allow designers to create re-usable BackWing, 
  # Instead of manually creating layout using Illusgtrator, designers should be able to "code" the design
  # so that developers do not have to hard coded the layout.
  # Designers should be able to design the layout with content set and corresponding layout.erb.
  class BackWing
    attr_reader :project_path, :output_path, :column, :content
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    include Styleable

    def initialize(options={})
      load_layout_rb
      load_text_style
      load_document      
      self
    end

    def set_width_and_height_from_paper_size
      if SIZES[@paper_size]
        @width = SIZES[@paper_size][0]
        @height = SIZES[@paper_size][1]
      elsif @paper_size.include?("*")
        @width = RLayout::mm2pt(@paper_size.split("*")[0].to_i)
        @height = RLayout::mm2pt(@paper_size.split("*")[1].to_i)
      elsif @paper_size.include?("x")
        @width = RLayout::mm2pt(@paper_size.split("x")[0].to_i)
        @height = RLayout::mm2pt(@paper_size.split("x")[1].to_i)
      end
      @width = @width/2
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def content_path
      @document_path + "/story.md"
    end

    def load_content
      if File.exist?(content_path)
        read_content
      else
        save_default_content
        read_content
      end
      layout_content
    end

    def read_content
      @story  = Story.new(content_path).markdown2para_data
      @heading = @story[:heading] || {}
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:extra_info]    = para[:extra_info]
        para_options[:line_width]     = @column.column_width  if para_options[:create_para_lines]
        @paragraphs << RParagraph.new(para_options)
      end
    end
  
    def layout_content
      if @heading
        make_heading_and_profile_image
      end
      flowing_items = @paragraphs.dup
      current_line = @document.first_text_line
      while @item = flowing_items.shift do
        current_line = @item.layout_lines(current_line)
      end
      if  current_line
        @current_column  = current_line.column
      end

    end


    # make heading and profile_image float
    def make_heading_and_profile_image
      h = {}
      h[:is_float]      = true
      h[:parent]        = @document
      h[:x]             = 2
      h[:y]             = 0
      h[:width]         = @width - 4
      h[:height]        = 70
      h[:style_name]    = 'title'
      # h[:sides] = [0,0,0,1]
      # h[:stroke_thickness] = 0.3
      h[:text_string] = @heading['title']
      @heading_title = TitleText.new(h)
      if @heading['profile_image']
        h = {}
        h[:is_float]      = true
        h[:parent]        = @document
        h[:x]             = 2
        h[:y]             = @heading_title.height
        h[:width]         = @width/2
        h[:image_path]    = profile_images_path + "/#{@heading['profile_image']}"
        @float_image = RLayout::Image.new(h)
      end
      @document.layout_floats
      @document.adjust_overlapping_lines_with_floats
    end

    def default_layout_rb
      # before rotating 90 
      # TODO: fix right_inset not working properly
      layout =<<~EOF
      RLayout::RColumn.new(width:#{@width}, height:#{@height}, left_side_bar: 80, top_inset: 5, left_inset: 5, right_inset: 10, body_line_height: 16) do
      end

      EOF
    end

    def save_default_content
      File.open(content_path, 'w'){|f| f.write default_content}
    end

    def default_content
      h =<<~EOF
      ---

      title: 추천 도서

      ---


      ## 내가 살아 가는 법
      {side_image: 'book_1.jpg'}

      이책은 홍긱동의 첫번째 소설로 30만부 
      판매된 인기 소설 입니다. 이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다. 
      이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다.


      ## 우리가 살아 가는 법
      {side_image: 'book_2.jpg'}

      이책은 홍긱동의 첫번째 소설로 30만부 
      판매된 인기 소설 입니다. 이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다. 
      이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다.


      ## 니가 살아 가는 법
      {side_image: 'book_3.jpg'}

      이책은 홍긱동의 첫번째 소설로 30만부 
      판매된 인기 소설 입니다. 이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다. 
      이책은 홍긱동의 첫번째 소설로 30 만부 판매된 인기 소설 입니다.

      EOF
    end

    def default_text_style
      <<~EOF
      body:
        korean_name: 본문명조
        category:
        font_family: Shinmoon
        font: Shinmoon
        font_size: 9.8
        first_line_indent: 0
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.4
        space_width: 3.0
        scale: 98.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
      body_gothic:
        korean_name: 본문고딕
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 9.6
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.2
        space_width: 3.0
        scale: 100.0
        first_line_indent: 0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:  
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      running_head:
        korean_name: 본문중제
        font_family: KoPub돋움체_Pro Bold
        font: KoPubDotumPB
        font_size: 11
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.2
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
      caption_title:
        korean_name: 사진제목
        category:
        font_family: KoPub돋움체_Pro Bold
        font: KoPubDotumPB
        font_size: 9.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.2
        space_width: 2.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      caption:
        korean_name: 사진설명
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.5
        space_width: 1.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      source:
        korean_name: 사진출처
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: right
        tracking: -0.2
        space_width: 2.0
        scale: 70.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        text_height_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      author:
        korean_name: 저자명
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 10.0
        text_color: CMYK=0,0,0,100
        text_alignment: right
        tracking: 0.0
        space_width: 2.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 0
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title:
        korean_name: 제목
        font: KoPubDotumPM
        font_size: 18.0
        text_color: CMYK=0,0,0,100
        text_alignment: center
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing: 0
        space_before: 30
        space_after: 30
      subtitle:
        korean_name: 부제_12_고딕
        font: KoPubDotumPM
        font_size: 18.0
        text_color: CMYK=100,0,0,100
        text_alignment: center
        tracking: -1.0
        space_width: 6.0
        scale: 100.0
        text_line_spacing: 6.0
        space_before_in_lines: 0.5
        space_after_in_lines: 0.5
        space_before: 10
        space_after: 10
      subject_head:
        korean_name: 문패_14
        category:
        font_family: KoPub돋움체_Pro Bold
        font: KoPubDotumPB
        font_size: 14.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.5
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
      EOF
    end
      
  end

end