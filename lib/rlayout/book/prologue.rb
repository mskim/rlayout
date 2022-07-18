module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  class Prologue < Chapter
    attr_reader :book, :path, :layout_template_path

    def initialize(options={})
      @doc_type = options[:doc_type] || 'chapter'
      @book_info = options.dup
      @jpg = options[:jpg] || false
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @starting_page_number  = options[:starting_page_number] || 1
      @output_path = options[:output_path] || @document_path + "/chapter.pdf"
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin]
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @page_pdf =  options[:page_pdf] || false
      @body_line_count = options[:body_line_count]
      @book_title = options[:book_title]      
      super
      options[:heading_height_type] = "natural"
      @output_path = @document_path + "/chapter.pdf"
      self
    end

    def load_defaults
      FileUtils.mkdir_p(@style_guide_folder) unless File.exist?(@style_guide_folder)
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

    def self.sample_story
      s =<<~EOF
      ---

      title: 이글을 쓰면서

      ---

      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 

      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 

      EOF
    end

    def story_md_path
      @path + "/story.md"
    end

    def layout_path
      @path + "/layout.rb"
    end

    def save_layout
      FileUtils.mkdir_p(@path) unless File.exist?(@path)
      if @layout_template_path

      else
        save_default_layout
      end
    end

    def generate_pdf
      save_layout
      d = eval(layout_rb)
      d.save_pdf(@output_path, jpg:true)
    end

    def save_default_layout
      File.open(layout_path, 'w'){|f| f.write layout_rb}
    end

    def layout_options
      h = {}
      h[:document_path] = @path
      h[:heading_height_type] = "quarter"
      h[:width] = @width
      h[:height] = @height
      h[:left_margin] = @left_margin
      h[:right_margin] = @right_margin
      h[:top_margin] = @top_margin
      h[:bottom_margin] = @bottom_margin
      h[:page_pdf] = true
      h[:toc] = true
      h
    end

    def default_layout_rb
      s =<<~EOF
        RLayout::RDocument.new(#{layout_options})
      EOF
    end
  end
end