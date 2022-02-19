module RLayouot
  # Styleable
  # Styleable module is included in Class for customizable text_style support.
  # Chapter, Toc, Front_matter_doc, Column_Article, MagazineArticle, 
  # CoverPage, PartCover, Isbn, etc ...

  module RLayout::Styleable
    attr_reader :global_text_style_path

    def text_style_path
      @document_path + "/#{self.class}_text_style.yml"
    end
    
    def save_text_style
      File.open(text_style_path, 'w'){|f| f.write default_text_style} unless File.exist?(text_style_path)
    end

    def save_text_style_to_global_style(global_style_folder)
      global_style_path = global_style_folder + "/#{self.class}_text_style.yml"
      File.open(global_style_path, 'w'){|f| f.write default_text_style} unless File.exist?(text_style_path)
    end
    
    #  use custom_style if @book_info[:custome_sylte] is true
    def load_text_style
      if @custom_style
        if File.exist?(text_style_path)
          RLayout::StyleService.shared_style_service.current_style = YAML::load_file(text_style_path)
        else
          File.open(text_style_path, 'w'){|f| f.write default_text_style}
        end
      else
        RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
      end
    end

    def default_text_style
      s=<<~EOF
      ---
      body:
        font: Shinmoon
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
      paper_size: A4
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
        # RLayout::ColumnArticle.new(document_path, custom_style: true)
        #{self.class}.new(document_path, custom_style: true)
      end
      
      EOF
    end


  end




end