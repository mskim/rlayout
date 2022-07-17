
# There are three types of Text.
# Text, TitleText, and RParagraph

# Text 
# supports single line untiform styled text.

# TitleText 
# supports multiple line text.
# used for title, subject_head, quote
# adjust_size  adjusts font size from default text_style value
# ex: My title text{-5} will reduce title text by 5 points
# only sinngle digit change is allowed, to keep design integrity.

# RParagraph
# supports multiple line text using style_name.
# used with RLineFragment of RColumn 
# it lays out  text_tokens in series of linkd RLineFragment's
# RParagraph is used in middle to long document.

# announcement paragragraph
# line takes up 2 or multiples of body_line_height
# it has line space of 1 before

# ruby_pdf supported attributes
# * Style#font
# * Style#font_size
# * Style#horizontal_scaling
# * Style#character_spacing
# * Style#word_spacing
# * Style#text_rise
# * Style#text_rendering_mode
# * Style#subscript
# * Style#superscript
# * Style#underline
# * Style#strikeout
# * Style#fill_color
# * Style#fill_alpha
# * Style#stroke_color
# * Style#stroke_alpha
# * Style#stroke_width
# * Style#stroke_cap_style
# * Style#stroke_join_style
# * Style#stroke_miter_limit
# * Style#stroke_dash_pattern
# * Style#underlay_callback
# * Style#overlay_callback



module RLayout
  #TODO
  # tab stop

  BOLD_STRING    = /(\*\*.*?\*\*)/ # **some bold string**
  ITALIC_STRING    = /(\*\*.*?\*\*)/ # **some italic string**

  EMPASIS_STRONG    = /(\*\*.*?\*\*)/ # **some strong string**
  EMPASIS_DIAMOND   = /(\*.*?\*)/    # *empais diamond string*
  EMPASIS_ARROW     = /(\*▲.*?\*)/    # *empais downarrow string*

  FOOTNOTE_MARKER = /\[\^(\d*?)\]/      #[^1]
  FOOTNOTE_TEXT_ITEM = /^\[\^(\d*?)\]:/      #[^1]: footnote description text
  FOOTNOTE_TEXT_ITEM_NUMBER = /^\[\^(\d*?)\]:/
  FOOTNOTE_MARKER_WITH_SPACE = /(\s\[\^\d*?\])/      # word [^1]

  # footnote_marker is marker with footnote number next to a word in paragraph.
  # footnote_text is description for footnote_marker.
  # has_footnote_marker: true if para has footnote_marker
  
  # footnote_text_items shoule be written at the start of new line as following
  # example

  # This is some text word[^1] and other[^2] and let see how it is presented.
  #
  # [^1]: word means Englishing work
  #
  # [^2]: other means other
  
  # Ths is second paragraph[^3] with footnote marker
  #
  # [^3]: paragraph means a collection of words.
  # 

  MATH_STRING = /\$.*?\$/
  # has_math_string
  # this has math $\frac{a}{b}$ token.

  RLAYOUT_STRING = /{{.*?}}/
  # has_erb_string
  # this has rlyout {{ "my_string".ruby("stop_string") }} token.
  # this has rlyout {{ "my_string".each_top_char("*") }} token.
  # this has rlyout {{ "my_string".bottom("bottom_string") }} token.
  # this has rlyout {{ "my_string".box") }} token.

  class RParagraph
    attr_reader :markup, :move_up_if_room
    attr_reader :para_string, :style_name, :para_style, :space_width
    attr_reader :article_type
    attr_reader :body_line_height, :line_count, :token_union_style
    attr_reader :line_width,  :token_heights_are_equal
    attr_accessor :tokens, :para_lines, :pdf_doc
    attr_reader :para_rect
    attr_reader :float_info 
    attr_reader :style_object, :style_object_bold, :style_object_italic
    attr_reader :extra_info
    attr_reader :has_footnote_marker, :footnote_markers
    attr_reader :has_math_string
    attr_reader :has_bold_string
    attr_reader :has_itlic_string

    attr_reader :drap_cap_object
    attr_reader :drop_lines, :drop_char_count
    def initialize(options={})
      @tokens = []
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      @extra_info     = options[:extra_info]
      @line_count     = 0
      @line_width     = options[:line_width] || 130
      @article_type   = options[:article_type]
      set_style_name_from_markup
      add_drop_cap if options[:draw_drap_cap]

      if @markup == 'br'
      else
        @tokens       = []
        create_tokens
      end
      @float_info = options[:float_info]
      self
    end

    def add_drop_cap
      # h  = {}
      # h[:parent] = self
      # @drapcap_object = DropCap.new(**h)
    end
    # para_info is used to display editing UI from front-end
    def para_info
      h = {}
      h[:markup]      = @markup
      h[:para_sting]  = @para_string
      h[:style_name]  = @style_name
      h[:para_rect]   = @para_rect
      h
    end

    # check if we have any empasized tokens, marked EMPASIS_STRONG or EMPASIS_DIAMOND
    # if EMPASIS_STRONG or EMPASIS_DIAMOND are found, split para string with EMPASIS_STRONG and EMPASIS_DIAMOND segments
    # and handle them separately.
    def create_tokens
      # TODO: fix this ???
      if @markup == "h4" || @markup == "h1"
        # for author and linked to page, check if there is markup for moving up the text, if there is enoung text_area[2]
        if  @para_string =~/\s?\^\s?$/
          @para_string = @para_string.sub(/\s?\^\s?$/, "")
          @move_up_if_room = true
        end
      end

      # TODO check if there is a space between work and footnote_marker like word [^1]
      # if so delte the space between them

      # collect all footnote marker numbers into @footnote_markers array
      if @para_string =~FOOTNOTE_MARKER
        @has_footnote_marker = true
        @footnote_markers = @para_string.scan(FOOTNOTE_MARKER).flatten
      end

      # check if there is any bold, italic, or math strings,
      # the tricky part is that they may contain space characters within the range, 
      # making it tricky for creating multiple token from series of words.
      # if so, one of the solution is to first merge all the word as a single string and split it back to word.
      # merge string as single string by replacing space with "<sp>" for easy parsing.
      check_for_math_string
      # check if there is any bold_token **bold**, if so merge string as single without space
      check_for_bold_string
      # check if there is any italic_token *italic*, if so merge string as single without space
      check_for_italic_string
      # create tokens from merged @para_string
      create_tokens_with_merged_strings(@para_string)
      token_heights_are_equal = true
      return unless  @tokens.length > 0
      tallest_token_height = @tokens.first.height
      @tokens.each do |token|
        if token.height > tallest_token_height
          token_heights_are_equal = false
          return
        end
      end
    end

    def escape_math_string(math)
      @escaped_string   = math.gsub("\\","!") 
      # @escaped_string   = Shellwords.escape(@escaped_string)   
      @escaped_string   = @escaped_string.gsub(" ","<sp>") 
    end

    def check_for_math_string
      if @para_string =~MATH_STRING
        @has_math_string = true
        math_strings = @para_string.scan(MATH_STRING).flatten
        math_strings.each do |math|
          @para_string.gsub!(math, escape_math_string(math))
        end
      end
    end

    def check_for_bold_string
      if @para_string =~BOLD_STRING
        @has_bold_string = true
        bold_strings = @para_string.scan(BOLD_STRING).flatten
        bold_strings.each do |bold|
          @para_string.gsub!(bold, merge_emphsis_strings_into_one(bold))
        end
      end
    end

    def check_for_italic_string
      if @para_string =~ITALIC_STRING
        @has_math_string = true
        italic_strings = @para_string.scan(ITALIC_STRING).flatten
        italic_strings.each do |italic|
          @para_string.gsub!(italic, merge_emphsis_strings_into_one(italic))
        end
      end
    end

    # merge emphsis strings into single string by replacing
    # space char with "<sp>" templarily, to make it easy for parsing.
    # **this is bold** => **this<sp>is<sp>bold**
    # __this is bold__ => __this<sp>is<sp>bold__
    # and when generating tokens, this string is reverted back into word original string.
    # this seem lots simpler to parse tokens.  
    def merge_emphsis_strings_into_one(string)
      string.gsub(" ","<sp>") 
    end

    def create_tokens_with_merged_strings(para_string)
      # parse for tab first
      return unless para_string
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object = @current_style_service.style_object(@style_name)
      para_string.split(" ").each do |token_string|
        next unless token_string
        if token_string =~MATH_STRING
          options = {}
          options[:token_type]  = 'math'
          # options[:escaped_string] = token_string
          latex_string = token_string.gsub("!", "\\")
          options[:latex_string] = latex_string.gsub("<sp>", " ")
          options[:height] = @style_object.font_size
          @tokens << RLayout::LatexToken.new(options)
        elsif token_string =~BOLD_STRING
          options = {}
          options[:token_type] = 'bold'
          options[:string] = token_string
          options[:height] = @style_object.font_size
          options[:style_object] = @style_object
          @tokens << RLayout::RTextToken.new(options)
        elsif token_string =~ITALIC_STRING
          options = {}
          options[:token_type]  = 'italic'
          options[:string] = token_string
          options[:height] = @style_object.font_size
          options[:style_object] = @style_object
          @tokens << RLayout::RTextToken.new(options)
        else
          options = {}
          options[:token_type]  = 'plain'
          options[:string]      = token_string
          options[:height]      = @style_object.font_size
          options[:style_object] = @style_object
          @tokens << RLayout::RTextToken.new(options)
        end
      end
    end

    # def create_tokens_with_emphasis_strong(para_string)
    #   para_string.chomp!
    #   para_string.sub!(/^\s*/, "")
    #   split_array = para_string.split(EMPASIS_STRONG)
    #   # splited array contains strong content
    #   split_array.each do |token_group|
    #     if token_group =~EMPASIS_STRONG
    #       token_group.gsub!("**", "")
    #       # get font and size
    #       current_style = RLayout::StyleService.shared_style_service.current_style
    #       style_hash = current_style['body_gothic'] #'strong_emphasis'
    #       @emphasis_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
    #       @current_style_service = RLayout::StyleService.shared_style_service
    #       @style_object = @current_style_service.style_object(@style_name) 
    #       tokens_array = token_group.split(" ")
    #       tokens_array.each do |token_string|
    #         emphasis_style              = {}
    #         emphasis_style[:string]     = token_string
    #         emphasis_style[:height]     = @emphasis_para_style[:font_size]
    #         token_options[:style_object] = @style_object
    #         @tokens << RLayout::RTextToken.new(emphasis_style)
    #       end
    #     else
    #       # line text with just noral text tokens
    #       create_plain_tokens(token_group)
    #     end
    #   end
    # end

    # def create_tokens_with_emphasis_diamond(para_string)
    #   para_string.chomp!
    #   para_string.sub!(/^\s*/, "")
    #   split_array = para_string.split(EMPASIS_DIAMOND)
    #   # splited array contains strong content
    #   split_array.each do |token_group|
    #     if token_group =~EMPASIS_DIAMOND
    #       token_group.gsub!("*", "")
    #       # get font and size
    #       if token_group =~ /◆/
    #         token_group = token_group + "="
    #       else
    #         token_group.strip!
    #         token_group = "◆" + token_group + " ="
    #       end
    #       current_style = RLayout::StyleService.shared_style_service.current_style
    #       style_hash = current_style['body_gothic'] #'diamond_emphasis'
    #       @diamond_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
    #       @current_style_service = RLayout::StyleService.shared_style_service
    #       @style_object = @current_style_service.style_object(@style_name) 
    #       tokens_array = token_group.split(" ")
    #       tokens_array.each do |token_string|
    #         emphasis_style              = {}
    #         emphasis_style[:string]     = token_string
    #         # emphasis_style[:style_name] = 'body_gothic'
    #         # emphasis_style[:para_style] = @diamond_para_style
    #         emphasis_style[:height]     = @diamond_para_style[:font_size]
    #         emphasis_style[:token_type] = 'diamond_emphasis'
    #         token_options[:style_object] = @style_object
    #         @tokens << RLayout::RTextToken.new(emphasis_style)
    #       end
    #     else
    #       # line text with just noral text tokens
    #       # puts "token_group for plain: #{token_group}"
    #       create_plain_tokens(token_group)
    #     end
    #   end
    # end

    # def create_tokens_with_emphasis_arrow(para_string)
    #   para_string.chomp!
    #   para_string.sub!(/^\s*/, "")

    #   split_array = para_string.split(EMPASIS_DIAMOND)
    #   # splited array contains strong content
    #   split_array.each do |token_group|
    #     if token_group =~EMPASIS_ARROW
    #       token_group.gsub!("*▲", "")
    #       token_group.sub!("*", "")
    #       # get font and size
    #       unless token_group =~ />/
    #         token_group.strip!
    #         token_group = "▲" + token_group
    #       end
    #       current_style = RLayout::StyleService.shared_style_service.current_style
    #       style_hash = current_style['body_gothic'] #'diamond_emphasis'
    #       @diamond_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
    #       @current_style_service = RLayout::StyleService.shared_style_service
    #       @style_object = @current_style_service.style_object(@style_name)
    #       tokens_array = token_group.split(" ")
    #       tokens_array.each do |token_string|
    #         emphasis_style              = {}
    #         emphasis_style[:string]     = token_string
    #         # emphasis_style[:style_name] = 'body_gothic'
    #         # emphasis_style[:para_style] = @diamond_para_style
    #         emphasis_style[:height]     = @diamond_para_style[:font_size]
    #         emphasis_style[:token_type] = 'diamond_emphasis'
    #         token_options[:style_object] = @style_object
    #         @tokens << RLayout::RTextToken.new(emphasis_style)
    #       end
    #     else
    #       # line text with just noral text tokens
    #       create_plain_tokens(token_group)
    #     end
    #   end
    # end

    def is_member_of_body_blocks?(markup)
      body_block_member_markup =  %w[h1 h2  h3 h4  h5  h6 quote]
      body_block_member_markup.include?(markup)
    end

    def layout_lines(current_line, options={})
      return unless current_line
      @para_rect  = []
      tokens_copy = tokens.dup
      @current_line = current_line
      # TODO handle for multiple column para lines
      @starting_x = current_line.x.dup
      @starting_y = current_line.y.dup
      @para_rect  = [current_line.x, current_line.y,current_line.width, current_line.height]
      @line_count = 1
      @current_line.set_paragraph_info(self, "first_line")
      token = tokens_copy.shift
      if token && token.token_type == 'diamond_emphasis'
        # if first token is diamond emphasis, no head indent
        unless @current_line.first_text_line? 
          @current_line = @current_line.next_text_line
        end
        @current_line.layed_out_line = true
        @current_line.set_paragraph_info(self, "middle_line")
      # elsif @markup == 'h1' || @markup == 'h2' || @markup == 'h3' ||  @markup == 'h4' || @markup == 'quote'
      elsif is_member_of_body_blocks?(@markup) &&  !@current_line.first_text_line?
        if @para_style[:space_before_in_lines] == 1
          @current_line.layed_out_line = true
          unless @current_line.next_text_line
            @current_line = @current_line.parent.add_new_page if @current_line.parent.respond_to?(:add_new_page)
          end
          @current_line = @current_line.next_text_line
        end
        if @para_style[:space_after_in_lines] == 1
          @space_after_in_lines = @para_style[:space_after_in_lines]
        end

        @current_line.layed_out_line = true
        @current_line.token_union_style = @token_union_style if @token_union_style
        if @markup == 'h2' && @extra_info
          extra_hash = eval(@extra_info)
          if extra_hash[:side_image]
            h = {}
            # h[:image_path] = extra_hash['side_image']
            h[:parent] = @current_line.parent
            h[:image_path] = h[:parent].local_image_path + "/#{extra_hash[:side_image]}"
            h[:x] = 5
            h[:y] = @current_line.y
            h[:width] = 70
            h[:height] = 80
            RLayout::Image.new(h)
          end
        end
        # @current_line = @current_line.next_text_line
        # return true unless @current_line
        @current_line.set_paragraph_info(self, "middle_line")
      elsif @markup == 'image'
        column = @current_line.column
        page = column.page
        @float_info[:markup] = 'image'
        # check if page has image
        # allow one image per page unless they are page_image_collection
        if page.has_image?
          @current_line = page.add_new_page
          column = @current_line.column
          page = column.page
          page.add_float(@float_info)
        elsif !page.first_page? && page.has_image? && page.last_page?
          # add new page
          if @current_line.y <= page.height/2
            float_info[:y] = page.mid_height
            page.add_float(@float_info)
          else
            if page.last_page?
              @current_line = page.add_new_page
              column = @current_line.column
              page = column.page
              page.add_float(@float_info)
            else
              float_info[:y] = page.mid_height
              page.next_page.add_float(@float_info)
            end
          end
        else
          if @current_line.y <= page.height/2
            float_info[:y] = page.mid_height
            page.add_float(@float_info)
          else
            @current_line = page.add_new_page
            column = @current_line.column
            page = column.page
            page.add_float(@float_info)
          end
        end
      elsif @markup == 'table'
        column = @current_line.column
        page = column.page
        @float_info[:markup] = 'table'
        page.add_float(@float_info)
      end

      # if @current_line.text_area[2] != @current_line.text_area[2]
      #   @current_line.text_area[2] = @current_line.text_area[2]
      # end
      while token
        return unless @current_line
        result = @current_line.place_token(token)
        # token is broken into two, second part is returned
        if result.class == RTextToken
          @current_line.align_tokens
          @current_line.room = 0
          new_line = @current_line.next_text_line
          if new_line
            @current_line = new_line
            column = @current_line.column
            page = column.page
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
            token = result
          else
            @current_line = @current_line.parent.add_new_page if @current_line.parent.respond_to?(:add_new_page)
            # break #reached end of last column
            # tokens_copy.unshift(result) #stick the unplace token back to the tokens_copy
            token = result
            column = @current_line.column
            page = column.page
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
          end
        elsif result
          if token.has_footnote_marker
            @current_line.add_footnote_description_to_column(token) 
          end
          # puts "entire token placed succefully, returned result is true"
          token = tokens_copy.shift
        # entire token was rejected,
        else
          @current_line.align_tokens
          @current_line.room = 0
          new_line = @current_line.next_text_line
          if new_line
            @current_line = new_line
            column = @current_line.column
            page = column.page
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
          else
            if @current_line.parent.fixed_page_document?
              return nil
            end
            if @current_line.parent.respond_to?(:add_new_page)
              @current_line = @current_line.parent.add_new_page 
              # tokens.unshift(token) #stick the unplace token back to the tokens_copy
              # break #reached end of column

              column = @current_line.column
              page = column.page
              @current_line.set_paragraph_info(self, "middle_line")
              @line_count += 1
            end
          end
        end
      end
      if @line_count == 1 && @current_line.line_type == 'first_line'
        @current_line.text_alignment = 'left'
      else
        @current_line.set_paragraph_info(self, "last_line")
      end
      @current_line.align_tokens
      @current_line= @current_line.next_text_line if @space_after_in_lines

      if @move_up_if_room 
        if found_previous_line = previous_line_has_room(@current_line)
          move_tokens_to_previous_line(@current_line, found_previous_line)
          @current_line.layed_out_line = false
          @para_rect[3] = @current_line.y + @current_line.height - @starting_y 
          @current_line
        else
          @para_rect[3] = @current_line.y + @current_line.height - @starting_y 
          @current_line.next_text_line
        end
      else
        @para_rect[3] = @current_line.y + @current_line.height - @starting_y 
        @current_line.next_text_line
      end

    end

    def previous_line_has_room(current_line)
      previous_line = current_line.previous_text_line
      return previous_line if previous_line.room > current_line.text_length
      false
    end

    def move_tokens_to_previous_line(line, p_line)
      line.graphics.each do |token|
        token.parent = p_line
        p_line.graphics << token
      end
      line.graphics = []
    end

    def is_breakable?
      return true  if @graphics.length > 2
      false
    end

    def to_hash
      h = {}
      h[:width]           = @width
      h[:markup]          = @markup
      h[:para_style]      = @para_style
      h[:linked]          = true
      h
    end

    def set_style_name_from_markup
      current_style = RLayout::StyleService.shared_style_service.current_style
      if current_style.class == String
        if current_style =~/^---/
          current_style = YAML::load(current_style) 
        else
          current_style = eval(current_style) 
        end
      end
      if @markup =='p' || @markup =='br'
        @style_name  = 'body'
        style_hash = current_style[@style_name]
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end
      # h1 $ is  assigned as reporrter
      if @markup =='h1'
        if @article_type == '사설' || @article_type == 'editorial' || @article_type == '기고'
          @style_name  = 'reporter_editorial'
          style_hash = current_style[@style_name]
          @graphic_attributes = style_hash['graphic_attributes']
          if @graphic_attributes == {}
          elsif @graphic_attributes == ""
          elsif @graphic_attributes.class == String
            @graphic_attributes = eval(@graphic_attributes)
          end
          if @graphic_attributes.class == Hash
            @token_union_style = @graphic_attributes['token_union_style']
            @token_union_style = Hash[@token_union_style.map{ |k, v| [k.to_sym, v] }]
          end
        else
          # TODO fix this
          @style_name  = 'reporter'
          style_hash = current_style[@style_name]
          if style_hash.nil?
            @style_name  = 'title'
            style_hash = current_style[@style_name]
          end
        end
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h2'
        @style_name  = 'running_head'
        style_hash = current_style[@style_name]
        unless style_hash
          # TODO add running_head to current style hash
          # make it to see which is the current style
          style_hash = current_style['head'] || current_style['h2']
        end
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h3'
        @style_name  = 'body_gothic'
        style_hash = current_style[@style_name]
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup == 'h4'
        @style_name  = 'linked_story'
        style_hash = current_style[@style_name]
        @para_style  = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
        # @para_string = "▸▸" + @para_string
        # @para_string = "▸▸" + @para_string
        @para_string = "\u25b6\u25b6" + " " + @para_string
      end
      if @markup == 'quote'
        @style_name  = 'quote'
        style_hash = current_style[@style_name]
        @para_style  = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end
      unless @para_style
        @style_name  = 'body'
        style_hash = current_style[@style_name]
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      @space_width  = @para_style[:space_width]
      if @space_width.nil?
        font_size   = @para_style[:font_size]
        @space_width = font_size/2
      end
    end

    def filter_list_options(h)
      list_only = Hash[h.select{|k,v| [k, v] if k=~/^list_/}]
      Hash[list_only.collect{|k,v| [k.to_s.sub("list_","").to_sym, v]}]
    end


  end


  # TODO is_float????
  class DropCap < Container
    attr_reader :text_string
    def initialize(options={})
      super

      self
    end
  end

end
