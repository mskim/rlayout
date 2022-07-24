module RLayout
  class PageBreakToken
    attr_reader :token_type, :width, :height

    def initialize(options={})
      @token_type = 'page_break'
      @width = 0
      @height = 0
      self
    end
  end

  class FitPage
    attr_reader :page_path, :book_path, :page_number, :text_style
    attr_reader :toc_content, :overflow
    attr_reader :current_style

    def initialize(page_path, page_content)
      @page_path = page_path
      @page_number = File.basename(@page_path).to_i
      @story_path = @page_path + "/#{@page_number}.md"
      FileUtils.mkdir_p(@page_path)  unless File.exist?(@page_path)
      if page_content
        @story_md = page_content 
        File.open(story_path, 'w'){|f| f.write page_content}
      end
      @book_path = File.dirname(File.dirname(@page_path))
      @output_path = @page_path + "/#{@page_number}.pdf"
      load_layout
      load_text_style
      @document = eval(@layout_rb)
      read_story
      layout_story
      @document.save_pdf(@output_path)
      fit_page
      self
    end

    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      # @heading  = @story[:heading] || {}
      # @title    = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      # @first_page = @document.pages[0]
      # if @first_page.has_heading?
      #   @document.pages[0].get_heading.set_heading_content(@heading)
      #   @document.pages[0].relayout!
      # else
      #   @heading[:parent] = @first_page
      #   @heading[:x]      = @first_page.left_margin # left_margin + binding_margin
      #   @heading[:y]      = @first_page.top_margin
      #   @heading[:width]  = @first_page.content_width # - @first_page.left_margin - @first_page.right_margin
      #   @heading[:is_float] = true
      #   @heading[:heading_height_type] = 'quarter' # 9 as line_count
      #   @heading[:heading_height_in_line_count] = @heading_height_in_line_count # 9 as body_line_count
      #   RHeading.new(@heading)
      #   @first_page.layout_floats
      #   @first_page.adjust_overlapping_columns
      # end
      @paragraphs =[]
      @image_count = 0
      @left_margin = @document.pages[0].left_margin
      @top_margin = @document.pages[0].top_margin
      @width = @document.pages[0].width
      @story[:paragraphs].each do |para, i|
        if  para[:markup] == "image"
          @image_count += 1
          float_info = {}
          # float_info[:position] = 1
          float_info[:x] = @left_margin
          float_info[:y] = @top_margin
          float_info[:width] = @width - @left_margin*2
          float_info[:height] = (@height - @top_margin*2)/2 - 20
          float_info[:image_path] = @local_image_folder + "/#{@image_count}.jpg"
          float_info[:kind] = "image"
          # TODO: fix this ????
          float_info[:image_path] =  Dir.glob("#{@local_image_folder}/#{@image_count}.{jpg,png,pdf}").first
          if float_info[:image_path] && File.exist?(float_info[:image_path])
            extension = File.extname(float_info[:image_path])
            image_info_path = float_info[:image_path].sub("#{extension}", ".yml")
            if File.exist?(image_info_path)
              image_info = YAML::load_file(image_info_path)
              float_info.merge!(image_info)
            end
          end
          para_options = {}
          para_options[:markup] = "image"
          para_options[:float_info] = float_info
          @paragraphs << RParagraph.new(para_options)
        elsif  para[:markup] == "table"
        elsif  para[:markup] == "footnote_text"
          $footnote_description_list << para
        else
          para_options = {}
          para_options[:markup]         = para[:markup]
          para_options[:layout_expand]  = [:width]
          para_options[:para_string]    = para[:para_string]
          @paragraphs << RParagraph.new(para_options)
        end
      end
    end
    
    def re_generate_tokens
      @paragraphs =[]
      @image_count = 0
      @left_margin = @document.pages[0].left_margin
      @top_margin = @document.pages[0].top_margin
      @width = @document.pages[0].width
      @story[:paragraphs].each do |para, i|
        if  para[:markup] == "image"
          @image_count += 1
          float_info = {}
          # float_info[:position] = 1
          float_info[:x] = @left_margin
          float_info[:y] = @top_margin
          float_info[:width] = @width - @left_margin*2
          float_info[:height] = (@height - @top_margin*2)/2 - 20
          float_info[:image_path] = @local_image_folder + "/#{@image_count}.jpg"
          float_info[:kind] = "image"
          # TODO: fix this ????
          float_info[:image_path] =  Dir.glob("#{@local_image_folder}/#{@image_count}.{jpg,png,pdf}").first
          if float_info[:image_path] && File.exist?(float_info[:image_path])
            extension = File.extname(float_info[:image_path])
            image_info_path = float_info[:image_path].sub("#{extension}", ".yml")
            if File.exist?(image_info_path)
              image_info = YAML::load_file(image_info_path)
              float_info.merge!(image_info)
            end
          end
          para_options = {}
          para_options[:markup] = "image"
          para_options[:float_info] = float_info
          @paragraphs << RParagraph.new(para_options)
        elsif  para[:markup] == "table"
        elsif  para[:markup] == "footnote_text"
          $footnote_description_list << para
        else
          para_options = {}
          para_options[:markup]         = para[:markup]
          para_options[:layout_expand]  = [:width]
          para_options[:para_string]    = para[:para_string]
          @paragraphs << RParagraph.new(para_options)
        end
      end
    end

    def layout_story
      @toc_content = []
      # @document.pages.each do |page|
      #   page.layout_floats
      #   page.adjust_overlapping_columns
      #   page.set_overlapping_grid_rect
      #   page.update_column_areas
      # end
      @first_text_page  = @document.pages.select{|p| p.first_text_line}.first
      unless @first_text_page
        @current_line = @document.add_new_page
      else
        @current_line = @first_text_page.first_text_line
      end
      page_key                    = @current_line.page_number
      @story_by_page_hash         = {} # this is used to capture story_by_page info
      current_page_paragraph_list = []
      while @paragraph = @paragraphs.shift
        # TODO: capturing paragraph info to save @story_by_page
        @current_line = @paragraph.layout_lines(@current_line)
        current_page_paragraph_list     << @paragraph.para_info
        if @toc_level == 'title'
        elsif @paragraph.markup != 'p'
          toc_item = {}
          toc_item[:page] = page_key
          toc_item[:markup] = @paragraph.markup
          toc_item[:para_string] = @paragraph.para_string
          @toc_content << toc_item
        end
        unless @current_line
          @current_line  = @document.add_new_page
          unless @current_line 
            @overflow = true if @paragraph.tokens.last.parent == nil
          end
          # @story_by_page_hash[page_key] = current_page_paragraph_list
          # current_page_paragraph_list   = []
          # page_key                      = @current_line.page_number
        end
        # if @current_line.page_number != page_key
        #   @story_by_page_hash[page_key] = current_page_paragraph_list
        #   current_page_paragraph_list   = []
        #   # current_page_hash             = {}
        #   page_key                      = @current_line.page_number
        #   # current_page_hash[page_key]   = []
        # end
      end
    end

    def default_layout_path
      @book_path + "/style_guide/chapter/chapter_layout.rb"
    end

    def default_text_style_path
      @book_path + "/style_guide/chapter/chapter_text_style.yml"
    end

    def load_layout
      @layout_rb = File.open(default_layout_path, 'r'){|f| f.read}
      @text_style = YAML::load_file(default_text_style_path)
    end

    def load_text_style
      if File.exist?(default_text_style_path)
        @current_style = RLayout::StyleService.shared_style_service.current_style = YAML::load_file(default_text_style_path)
      else
        puts "text_style not found!!!"
      end
    end

    # layout page 
    # 1. adjust font_size for multiple line miss match
    # 2. adjust paragraph tracking
    # 2. adjust line tracking
    def first_page
      @document.first_page
    end

    def fit_page
      if @overflow
        puts "we have overflow"
        return
      end
      last_line =  first_page.last_line
      if last_line.last_paragraph_line?
        # if last token includes "."
        puts "it fits"
      elsif last_line.empty?
        #   adjust_page_content_with_font_size(last_line.extra_space)
        puts "last line is empty"
        return # check if the 
      elsif last_line.extra_space > last_line.width/2.0
        relayout_page_with_larger_font_size
      elsif last_line.extra_space > 100
        take_token_from_prev_line
      elsif last_line.extra_space < 100
        # if the room is small, change last line to 'middle' and redo align_token
        puts "re_align last line"
        last_line.line_type = 'middle_line'
        last_line.align_tokens
      end
      @output_path_fixed = @page_path + "/#{@page_number}_fixed.pdf"
      @document.save_pdf(@output_path_fixed)
    end

    def relayout_page_with_larger_font_size
      puts __method__
      puts @page_path
      @document = eval(@layout_rb)
      # set font_size
      # first try
      acceptable_extra_space = @current_style['body']['font_size']*4

      4.times do |i|
        puts "try No.#{i + 1}"
        @current_style['body']['font_size'] = @current_style['body']['font_size'] +  0.3
        puts "#{@current_style['body']['font_size']}"
        re_generate_tokens
        layout_story
        last_line =  first_page.last_line

        if last_line.extra_space < acceptable_extra_space
          last_line.relayout_line_to_fit(acceptable_extra_space)
          break
        end
      end
 
    end
    
    def take_token_from_prev_line
      puts __method__
      # reversed_text_lines  = first_page.text_lines.reverse
      # reversed_text_lines.each_with_index do |line, i|
      #   line.take_token_from_prev_line(reversed_text_lines[i+1])
      # end
    end
  end

end