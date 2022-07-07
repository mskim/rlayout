module RLayout
  
  # The goal is to create a re-usable document with customiable style_guide,
  # where style_guide contains all design related information for the publication.
  # Once style_guide is tweaked by the designer, 
  # similar publications can re-use the copy of the style_guide with new content.
  
  # Styleable module.
  # There are text_styles and layout_rb for each "styleable document".
  # StyleableDoc is super class for customizable document.
  # book_cover_docs
  #     front_page, back_page, seneca, front_wing, back_wing
  # front_matter_doc
  #     Toc, InsideCover, Isbn, Prologue, Preface, Thanks, Dedication
  # body_matter
  #     Chapter, PartCover, Column_Article, 
  # MagazineArticle, 
  #  MagazineArticle, MagazineToc, MagazineEditorNote, MagazinePreface
  #  NamecardMaker, 
  # Jubo

  #  def load_text_style
  #  read text_style if they exist or save default style so that designer can customize it.

  # def load_layout_rb
  # read rlayout.rb if they exist or save default layout_rb so that designer can customize it.
  
  # def load_header_footer
  # read header_footer.yml if they exist or save default layout_rb so that designer can customize it.


  # style_guide_folder
  # for books where multiple documents with same style are used, like chapters
  # text_styles are put in style_guide_folder
  
  module Styleable
    attr_reader :style_guide_folder
    attr_reader :document
    attr_reader :layout_rb
    # including class shold have the following class attributes
    # attr_reader :document_path
    # attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    # attr_reader :document
    # attr_reader :page_pdf
    # attr_reader :starting_page_number
    # attr_reader :output_path
    # attr_reader :header_footer_info
    # attr_reader :body_line_count
    # attr_reader :book_title, :chapter_title
    
    def load_doc_style
      load_defaults
      load_text_style
      load_layout_rb
      load_header_footer_info
      load_document
      self
    end

    def load_page_style
      load_text_style
      load_layout_rb
      load_document
      load_page_content
    end

    def style_guide_defaults_path
      @style_guide_folder + "/#{style_klass_name}_defaults.yml"
    end

    # allow values to be customizable
    def load_defaults
      if File.exist?(style_guide_defaults_path)
        default_options = YAML::load_file(style_guide_defaults_path)
      else
        default_options = YAML::load(defaults)
        File.open(style_guide_defaults_path, 'w'){|f| f.write defaults}
      end
      # TODO ??? how to set values to instance varible with same name
      @heading_height_type  = default_options['heading_height_type']
      @heading_height_in_line_count  = default_options['heading_height_in_line_count']
      @footnote_description_text_prefix = default_options['footnote_description_text_prefix']
    end

    def  defaults
      <<~EOF
      ---
      heading_height_type: quarter
      heading_height_in_line_count: 9
      # footnote_description_text_prefix: *
      EOF
    end

    def load_document
      if @layout_rb
        @document = eval(@layout_rb)
        if @document.is_a?(SyntaxError)
          puts "SyntaxError in #{@document} !!!!"
          return
        end
        unless @document.kind_of?(RLayout::RDocument) || @document.kind_of?(RLayout::Container)
          puts "Not a @document kind created !!!"
          return
        end
        # @document.local_image_path = local_image_path
      end
    end

    def local_image_path
      @document_path + "/images"
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

    def default_layout_rb
      doc_options= {}
      doc_options[:width] = @width
      doc_options[:height] = @height
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      doc_options[:body_line_count] = @body_line_count
      layout =<<~EOF
        RLayout::RDocument.new(#{doc_options})
      EOF
    end

    def style_guide_header_footer_path
      @style_guide_folder + "/#{style_klass_name}_header_footer.yml"
    end

    def load_header_footer_info
      if File.exist?(style_guide_header_footer_path)
        @header_footer_info = YAML::load_file(style_guide_header_footer_path)
      else
        @header_footer_info = YAML::load(default_header_footer_yml)
        File.open(style_guide_header_footer_path, 'w'){|f| f.write default_header_footer_yml}
      end
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
      @document.set_page_content(@page_content) if @document && @document.class == RLayout::CoverPage
    end

    def default_page_content
      <<~EOF
      ---
      heading:
        title : 2022년에 책만들기
        subtitle: 지난 40년간 해오던 편식방식을 개선하기
        author: 김민수

      ---
      
      EOF

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
        text_alignment: left
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
    
    #################  doc_info ##############

    def doc_info_path
      @document_path + "/doc_info.yml"
    end

    def default_doc_info
      h=<<~EOF
      ---
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