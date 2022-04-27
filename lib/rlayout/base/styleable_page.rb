module RLayout

  class StyleablePage
    attr_reader :document_path, :style_guide_folder
    attr_reader :page_content
    attr_reader :paper_size, :width, :height
    attr_reader :pdf_page
    attr_reader :document
    def initialize(options={})
      @document_path = options[:document_path]
      @pdf_page = options[:pdf_page]
      @paper_size = options[:paper_size] || 'A4'
      set_width_and_height_from_paper_size
      @style_guide_folder = options[:style_guide_folder] || @document_path
      load_layout_rb
      load_text_style
      @document = eval(@layout_rb)
      @document.local_image_path = local_image_path
      load_page_content
      @document.set_page_content(@page_content)
      @document.save_pdf(output_path, pdf_page:@pdf_page)
      self
    end

    def local_image_path
      @document_path + "/images"
    end
    # set width and height from @paper_size
    def set_width_and_height_from_paper_size
      if SIZES[@paper_size]
        @width = SIZES[@paper_size][0]
        @height = SIZES[@paper_size][1]
      elsif @paper_size.include?("*")
        @width = mm2pt(@paper_size.split("*")[0].to_i)
        @height = mm2pt(@paper_size.split("*")[1].to_i)
      elsif @paper_size.include?("x")
        @width = mm2pt(@paper_size.split("x")[0].to_i)
        @height = mm2pt(@paper_size.split("x")[1].to_i)
      end
    end

    def style_klass_name
      camel_cased_word = self.class.to_s.split("::")[1]
      underscore camel_cased_word
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def page_content_path
      @document_path + "/content.yml"
    end

    def load_page_content
      if File.exist?(content_path)
        @page_content = YAML::load_file(content_path)
      else
        @page_content = default_page_content
        File.open(content_path, 'w'){|f| f.write default_page_content}
      end
      @document.set_page_content if @document && @document.class == RLayout::CoverPage
    end

    def text_style_path
      @style_guide_folder + "/#{style_klass_name}_text_style.yml"
    end

    def load_text_style
      if File.exist?(text_style_path)
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(text_style_path)
      else
        RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
        FileUtils.mkdir_p(@style_guide_folder) unless File.exist?(@style_guide_folder)
        File.open(text_style_path, 'w'){|f| f.write default_text_style}
      end
    end

    def style_klass_name
      camel_cased_word = self.class.to_s.split("::")[1]
      underscore camel_cased_word
    end

    def underscore(camel_cased_word)
      camel_cased_word.to_s.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
    end

    def layout_rb_path
      @document_path + "/layout.rb"
    end

    def load_layout_rb
      if File.exist?(layout_rb_path)
        @layout_rb = File.open(layout_rb_path, 'r'){|f| f.read}
      else
        @layout_rb = default_layout_rb
        File.open(layout_rb_path, 'w'){|f| f.write default_layout_rb}
      end
    end

    def default_layout_rb
      <<~EOF
      RLayout::CoverPage::new(width:#{@width}, height:#{@height})

      EOF
    end

    def default_page_content
      <<~EOF
      ---

      title: 여기는 제목
      subtitle: 여기는 부제목
      author: 여기는 저자명

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
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.4
        space_width: 3.0
        scale: 98.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
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
        category:
        font_family: KoPub돋움체_Pro Medium
        font: KoPubDotumPM
        font_size: 9.6
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.2
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      quote:
        korean_name: 발문
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 12.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.5
        space_width: 6.0
        scale: 100.0
        text_line_spacing: 2
        space_before_in_lines: 2
        space_after_in_lines: 0
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      announcement_1:
        korean_name: 안내문1단
        category:
        font: KoPubDotumPM
        font_size: 12.0
        text_color: CMYK=0,0,0,0
        text_alignment: left
        tracking: -0.5
        space_width: 6.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 2
        space_after_in_lines: 0
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      announcement_2:
        korean_name: 안내문2단
        category:
        font: KoPubDotumPM
        font_size: 9.6
        text_color: CMYK=0,0,0,0
        text_alignment: left
        tracking: -0.5
        space_width: 6.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 2
        space_after_in_lines: 0
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
        publication_id: 1s
      related_story:
        korean_name: 관련기사
        category:
        font_family: KoPub돋움체_Pro Medium
        font: KoPubDotumPM
        font_size: 9.0
        text_color: CMYK=0,0,0,100
        text_alignment: right
        tracking: -0.5
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
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
      linked_story:
        korean_name: 연결기사
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.0
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
        publication_id: 1s
      title_main:
        korean_name: 제목_메인
        category:
        font_family: KoPub바탕체_Pro Bold
        font: KoPubBatangPB
        font_size: 42.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing: 0
        space_before_in_lines: 0.5
        space_after_in_lines: 0.5
        text_height_in_lines: 3
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_4_5:
        korean_name: 제목_4-5단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 32.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.5
        space_width: 10.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_4:
        korean_name: 제목_4단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 30.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -2.0
        space_width: 7.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_3:
        korean_name: 제목_3단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 27.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -2.0
        space_width: 4.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_2:
        korean_name: 제목_2단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 23.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -2.0
        space_width: 4.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      book_title:
        korean_name: 표지제목
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 24.0
        text_color: CMYK=0,0,0,100
        text_alignment: center
        tracking: -2.0
        space_width: 4.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 1
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title:
        korean_name: 제목_메인
        category:
        font_family: KoPub바탕체_Pro Bold
        font: KoPubBatangPB
        font_size: 24.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing: 0
        space_before_in_lines: 0
        space_after_in_lines: 0
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      subtitle_main:
        korean_name: 부제_메인
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 18.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.0
        space_width: 5.0
        scale: 100.0
        text_line_spacing: 6.0
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      subtitle_M:
        korean_name: 부제_14
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 14.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.0
        space_width: 5.0
        scale: 100.0
        text_line_spacing: 7.0
        space_before_in_lines: 0
        space_after_in_lines: 1
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      subtitle_S:
        korean_name: 부제_12
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 12.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.0
        space_width: 4.0
        scale: 100.0
        text_line_spacing: 6.0
        space_before_in_lines: 0
        space_after_in_lines: 1
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      subtitle:
        korean_name: 부제_12_고딕
        category:
        font_family: KoPub돋움체_Pro Medium
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
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      news_line_title:
        korean_name: 뉴스라인_제목
        category:
        font_family: KoPub돋움체_Pro Medium
        font: KoPubDotumPM
        font_size: 13.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -0.5
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      brand_name:
        korean_name: 애드_브랜드명
        category:
        font_family: KoPub돋움체_Pro Medium
        font: KoPubDotumPM
        font_size: 13.0
        text_color: CMYK=0,0,0,100
        text_alignment: center
        tracking: -0.5
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      subject_head_L:
        korean_name: 문패_18
        category:
        font_family: KoPub돋움체_Pro Bold
        font: KoPubDotumPB
        font_size: 18.0
        text_color: CMYK=100,50,0,0
        text_alignment: left
        tracking: -0.5
        space_width: 0.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes:
          token_union_style:
            stroke_width: 2
            stroke_sides:
              - 0
              - 1
              - 0
              - 0
            top_line_space: 5
      subject_head_M:
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
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      editor_note:
        korean_name: 편집자주
        category:
        font_family: KoPub돋움체_Pro Medium
        font: KoPubDotumPM
        font_size: 8.8
        text_color: CMYK=0,0,0,80
        text_alignment: left
        tracking: -0.3
        space_width: 3.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines:
        space_after_in_lines:
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_opinion:
        korean_name: 기고 제목
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 22.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.5
        space_width: 7.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_editorial:
        korean_name: 사설 제목
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 19.0
        text_color: CMYK=0,0,0,100
        text_alignment: left
        tracking: -1.5
        space_width: 5.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 0
        space_after_in_lines: 1
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_7:
        korean_name: 제목_7단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 36.0
        text_color: ''
        text_alignment: left
        tracking: -2.0
        space_width: 7.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_6:
        korean_name: 제목_6단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 34.0
        text_color: ''
        text_alignment: left
        tracking: -2.0
        space_width: 7.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_5:
        korean_name: 제목_5단
        category:
        font_family: KoPub바탕체_Pro Medium
        font: KoPubBatangPM
        font_size: 32.0
        text_color: ''
        text_alignment: left
        tracking: -2.0
        space_width: 7.0
        scale:
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 2
        text_height_in_lines: 2
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_main_7:
        korean_name: 제목_메인_7
        category:
        font_family: KoPub바탕체_Pro Bold
        font: KoPubBatangPB
        font_size: 45.0
        text_color: ''
        text_alignment: left
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 0
        text_height_in_lines: 3
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_main_6:
        korean_name: 제목_메인_6
        category:
        font_family: KoPub바탕체_Pro Bold
        font: KoPubBatangPB
        font_size: 45.0
        text_color: ''
        text_alignment: left
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 0
        text_height_in_lines: 3
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      title_main_5:
        korean_name: 제목_메인_5
        category:
        font_family: KoPub바탕체_Pro Bold
        font: KoPubBatangPB
        font_size: 42.0
        text_color: ''
        text_alignment: left
        tracking: -1.0
        space_width: 10.0
        scale: 100.0
        text_line_spacing:
        space_before_in_lines: 1
        space_after_in_lines: 0
        text_height_in_lines: 3
        box_attributes: ''
        markup: ''
        graphic_attributes: ''
      
      EOF
      
    end
    

  end


end