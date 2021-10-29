module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  class Poem < RChapter

    def initialize(options={})
      # @path = options[:document_path]
      # @width = options[:width] || 400
      # @height = options[:height] || 500
      # @layout_template_path = options[:layout_template_path]
      # read_poem
      # RLayout::StyleService.shared_style_service.set_poem_style

      super

      self
    end

    def read_story
      @first_page = @document.pages[0]
      @story  = Story.new(@story_path).story2line_text
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || @heading['title'] || "Untitled"
      # if @first_page && @first_page.has_heading?
      #   @first_page.get_heading.set_heading_content(@heading)
      #   @first_page.relayout!
      # elsif @first_page = @document.pages[0]
      #   if @first_page.floats.length == 0
      #     @heading[:parent] = @first_page
      #     @heading[:x]      = @first_page.left_margin
      #     @heading[:y]      = @first_page.top_margin
      #     @heading[:width]  = @first_page.width - @first_page.left_margin - @first_page.right_margin
      #     @heading[:is_float] = true
      #     RHeading.new(@heading)
      #   elsif @first_page.has_heading?
      #     @first_page.get_heading.set_heading_content(@heading)
      #   end
      # end

      @text_lines = []
      @story[:line_text].each do |line_text|
        @text_lines << line_text
      end
    end
  
    def layout_story
      # current_style = RLayout::StyleService.shared_style_service.set_poem_style
      # RLayout::StyleService.shared_style_service.set_poem_style

      # current_style.current_style = POEM_STYLES

      # @document.pages.each do |page|
      #   page.layout_floats
      #   page.adjust_overlapping_columns
      #   page.set_overlapping_grid_rect
      #   page.update_column_areas
      # end
      # @current_line               = @first_page.first_text_line
      # @story_by_page_hash         = {} # this is used to capter story_by_page info
      @toc_content                = []
      # page_key                    = @current_line.page_number
      # current_page_paragraph_list = []

      # title
      line_options = {}
      line_options[:x]  = 50
      line_options[:y]  = 30
      line_options[:width]  = @first_page.width
      line_options[:height]  = 50
      line_options[:text_string]    = @title
      line_options[:parent] = @first_page
      line_options[:font_size] = 16
      Text.new(line_options)

      # body
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

      # while @paragraph = @paragraphs.shift
      #   # capturing paragraph info to save @story_by_page
      #   @current_line                   = @paragraph.layout_lines(@current_line)
      #   current_page_paragraph_list     << @paragraph.para_info
      #   if @toc_level == 'title'
      #   elsif @paragraph.markup != 'p'
      #     toc_item = {}
      #     toc_item[:page] = page_key
      #     toc_item[:markup] = @paragraph.markup
      #     toc_item[:para_string] = @paragraph.para_string
      #     @toc_content << toc_item
      #   end
      #   unless @current_line
      #     @current_line                 = @document.add_new_page
      #     @story_by_page_hash[page_key] = current_page_paragraph_list
      #     current_page_paragraph_list   = []
      #     page_key                      = @current_line.page_number
      #   end

      #   if @current_line.page_number != page_key
      #     @story_by_page_hash[page_key] = current_page_paragraph_list
      #     current_page_paragraph_list   = []
      #     # current_page_hash             = {}
      #     page_key                      = @current_line.page_number
      #     # current_page_hash[page_key]   = []
      #   end
      # end
    end

    def save_toc
      @document_path  = File.dirname(@output_path)
      toc_path        = @document_path + "/toc.yml"
      toc_item = {}
      toc_item[:page] = @starting_page
      toc_item[:markup] = 'h1'
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

    def output_path
      @path + "/chapter.pdf"
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
      d.save_pdf_with_ruby(output_path, jpg:true)
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