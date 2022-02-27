module RLayout
  
  # The goal is to create a re-usable publication with style_guide,
  # where style_guide contains all design related information for the publication.
  # Once style_guide is tweaked by the designer, 
  # similar publications can re-use the copy of the style_guide with new content.
  
  # DocumentBase class is created for that purpose.
  # DocumentBase supports both text_styles and layout for each "unit document".
  # DocumentBase is super class for
  #  Chapter, Toc, Front_matter_doc, Column_Article, MagazineArticle, 
  #  CoverPage, PartCover, Isbn, etc ...
  #  MagazineArticle, MagazineToc, MagazineEditorNote, MagazinePreface


  class DocumentBase
    attr_reader :document_path, :paper_size, :width, :height
    attr_reader :style_klass_name

    def initialize(options={})
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @paper_size = options[:paper_size] || "A4"
      size_from_paper_size
      self
    end

    # set width and height from @paper_size
    def size_from_paper_size
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

    def save_custom_style
      save_doc_info
      save_text_style
      save_rakefile #??? or use cli at the path
    end

    def local_text_style_path
      @document_path + "/#{style_klass_name}_text_style.yml"
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

    def style_guide_path
      @style_guide_folder + "/#{style_klass_name}_text_style.yml"
    end

    def save_style_guide
      FileUtils.mkdir_p(@style_guide_folder) unless File.exist?(@style_guide_folder)
      File.open(style_guide_path, 'w'){|f| f.write self.default_text_style} unless File.exist?(style_guide_path)
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
    # 2. check if there is global_text_style(style_guide_path) file
    # 3. save default_text_style to style_guide_path
    # to override global style, copy text_style file to local folder
    # if style_guide_folder is not given, style_guide_folder is set to document_folder
    #   - this is useful when designing single unit documents
    def load_text_style
      if File.exist?(local_text_style_path)
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(local_text_style_path)
      elsif File.exist?(style_guide_path)
        RLayout::StyleService.shared_style_service.current_style = YAML::load_file(style_guide_path)
      else
        RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
        save_style_guide
        # File.open(style_guide_path, 'w'){|f| f.write default_text_style}
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
        markup: "#"
        text_alignment: left
        space_before: 1
      running_head_2:
        font: KoPubDotumPL
        font_size: 11.0
        markup: "##"
        text_alignment: middle
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