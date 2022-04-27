module RLayout
  
  # The goal is to create a re-usable document with customiable style_guide,
  # where style_guide contains all design related information for the publication.
  # Once style_guide is tweaked by the designer, 
  # similar publications can re-use the copy of the style_guide with new content.
  
  # StyleableArticle class.
  # There are text_styles and layout_rb for each "styleable document".
  # StyleableArticle is super class for customizable document.

  # NewsArticle, 
  #  NewsArticle, Opinion, Editorial, BookReview, Obituary
  #  NamecardMaker, 

  # Jubo

  #  def load_text_style
  #  read text_style if they exist or save default style so that designer can customize it.

  # def load_layout_rb
  # read rlayout.rb if they exist or save default layout_rb so that designer can customize it.

  # style_guide_folder
  # for books where multiple documents with same style are used, like chapters
  # text_styles are put in style_guide_folder
  
  class  StyleableArticle
    attr_reader :style_guide_folder
    attr_reader :document_path, :paper_size, :width, :height
    attr_reader :document
    attr_reader :page_pdf
    attr_reader :starting_page_number
    attr_reader :output_path

    def initialize(options={})
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @starting_page_number  = options[:starting_page_number] || 1
      @output_path = options[:output_path] || @document_path + "/chapter.pdf"
      @page_pdf =  options[:page_pdf] || true
      if options[:book_info]
        @book_info      = options[:book_info]
        @paper_size     = @book_info[:paper_size] || "A5"
        @book_title     = @book_info[:tittle] || "untitled"
      else
        @paper_size     = options[:paper_size] || "A5"
        @book_title     = options[:book_tittle] || "untitled"
      end      
      set_width_and_height_from_paper_size
      load_text_style
      load_layout_rb
      @document = eval(@layout_rb)
      @document.document_path = @document_path
      load_content
      @document.save_pdf(output_path)
      self
    end

    def local_image_path
      @document_path + "/images"
    end

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

    def save_text_style
      File.open(text_style_path, 'w'){|f| f.write default_text_style} unless File.exist?(text_style_path)
    end

    def text_style_path
      @document_path + "/text_style.yml"
    end
    
    def save_text_style
      File.open(text_style_path, 'w'){|f| f.write default_text_style} unless File.exist?(text_style_path)
    end

    def style_guide_text_style_path
      @style_guide_folder + "/#{style_klass_name}_text_style.yml"
    end

    def save_style_guide
      FileUtils.mkdir_p(@style_guide_folder) unless File.exist?(@style_guide_folder)
      File.open(style_guide_text_style_path, 'w'){|f| f.write self.default_text_style} unless File.exist?(style_guide_text_style_path)
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

    # 1. check if there is local_text_style file
    # 2. check if there is style_guide_text_style_path file
    # 3. save default_text_style to style_guide_text_style_path
    # to override global style, copy text_style file to local folder
    # if style_guide_folder is not given, style_guide_folder is set to document_folder
    #   - this is useful when designing single unit documents
    def load_text_style
      if File.exist?(style_guide_text_style_path)
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(style_guide_text_style_path)
      else
        RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
        save_style_guide
        # File.open(style_guide_text_style_path, 'w'){|f| f.write default_text_style}
      end
    end

    def style_guide_layout_path
      @style_guide_folder + "/#{style_klass_name}_layout.rb"
    end

    def load_layout_rb
      if File.exist?(style_guide_layout_path)
        @layout_rb = File.open(style_guide_layout_path, 'r'){|f| f.read}
      else
        @layout_rb = default_layout_rb
        File.open(style_guide_layout_path, 'w'){|f| f.write default_layout_rb}
      end
    end

    def width_ratio
      @width/SIZES['A4'][0]
    end

    def title_relative_size
      24*width_ratio.to_i
    end

    def subtitle_relative_size
      20*width_ratio.to_i
    end

    def author_relative_size
      16*width_ratio.to_i
    end

    def quote_relative_size
      18*width_ratio.to_i
    end

    def page_count
      @document.pages.length
    end

    # def default_layout_rb
    #   s=<<~EOF
    #   RLayout::RDocument.new(width:#{@width}, heihgt:#{@height})
    #   EOF
    # end

    def default_text_style
      <<~EOF
      body:
        korean_name: 본문명조
        category:
        font_family: Shinmoon
        font: Shinmoon
        font_size: 9.8
        first_line_indent: 9.8
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
    
    #################  doc_info ##############

    def doc_info_path
      @document_path + "/doc_info.yml"
    end

    def default_doc_info
      h=<<~EOF
      ---
      paper_size: #{@paper_size}
      doc_type: #{self.class}
      EOF
    end

    def save_doc_info
      File.open(doc_info_path, 'w'){|f| f.write default_doc_info} unless File.exist?(doc_info_path)
    end

    #################  Rakefile ##############

    def rakefile_path
      @document_path + "/Rakefile"
    end
    
    def save_rakefile
      File.open(rakefile_path, 'w'){|f| f.write rakefile} unless File.exist?(rakefile_path)
    end

    def rakefile
      s=<<~EOF
      require 'rlayout'
      
      task :default => [:generate_pdf]
      
      desc 'generate pdf'
      task :generate_pdf do
        document_path = File.dirname(__FILE__)
        #{self.class}.new(document_path:document_path)
      end
      
      EOF
    end

  end

end