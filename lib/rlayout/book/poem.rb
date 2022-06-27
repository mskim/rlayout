module RLayout

  # Poem text is layed out as is, unlike paragraph.
  # It respets 'return keys' and 'empty lines' as is.
  class Poem < Chapter
    def initialize(options={})
      @belongs_to_part = options[:belongs_to_part]
      super
      self
    end

    def read_story
      @first_page = @document.pages[0]
      @story  = Story.new(@story_path).story2line_text
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      @text_lines = []
      @story[:line_text].each do |line_text|
        @text_lines << line_text
      end
    end
  
    def layout_story
      @toc_content = []
      line_options = {}
      line_options[:x]  = 50
      line_options[:y]  = 30
      line_options[:width]  = @first_page.width
      line_options[:height]  = 50
      line_options[:text_string]    = @title
      line_options[:parent] = @first_page
      line_options[:font_size] = 16
      Text.new(line_options)
      @starting_y = 100
      line_height = 20
      @text_lines.each do |line_text|
        line_options = {}
        line_options[:x]  = 50
        line_options[:y]  = @starting_y
        line_options[:width]  = @first_page.width
        line_options[:height]  = line_height
        line_options[:text_string]    = line_text
        line_options[:parent] = @first_page
        line_options[:font_size] = 12
        Text.new(line_options)
        @starting_y += line_height
      end
    end

    def save_toc
      @document_path  = File.dirname(@output_path)
      toc_path        = @document_path + "/toc.yml"
      toc_item = {}
      toc_item[:page] = @starting_page_number
      toc_item[:markup] = 'h1'
      toc_item[:markup] = 'h2' if @belongs_to_part
      toc_item[:para_string] = @title
      @toc_content << toc_item
      File.open(toc_path, 'w') { |f| f.write @toc_content.to_yaml}
    end

    def story_md_path
      @path + "/story.md"
    end

    def layout_path
      @path + "/layout.rb"
    end

    def save_layout
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
      h[:heading_height_type] = "quarter"
      h[:width] = @width
      h[:height] = @height
      h[:page_pdf] = true
      h[:toc] = true
      h
    end

    def layout_rb
      s =<<~EOF
        RLayout::Container.new(#{layout_options}) do
        title_text("#{@title}", x: 50, y: 50, width: 400, style_name:'title')
        title_text("#{@body}", x: 50, y: 100, width: 400, height: 400, style_name:'body')
        end
      EOF
    end
  end
end