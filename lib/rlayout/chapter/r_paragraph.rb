
# Paragraph Object is used in middle to long document.
# Paragraph is not a Graphic subclass.
# Paragraph holds data tokens and resposible for laying out them out in lines.

# announcement paragragraph
# line takes up 2 or multples of body_line_height
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
  EMPASIS_STRONG    = /(\*\*.*?\*\*)/ # **some strong string**
  EMPASIS_DIAMOND   = /(\*.*?\*)/    # *empais diamond string*
  EMPASIS_ARROW     = /(\*▲.*?\*)/    # *empais downarrow string*

  class RParagraph
    attr_reader :markup, :move_up_if_room
    attr_reader :para_string, :style_name, :para_style, :space_width
    attr_reader :article_type
    attr_reader :body_line_height, :line_count, :token_union_style
    attr_reader :line_width,  :token_heights_are_equal
    attr_accessor :tokens, :para_lines, :pdf_doc
    attr_reader :para_rect
    attr_reader :float_info
    def initialize(options={})
      @tokens = []
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      @line_count     = 0
      @line_width     = options[:line_width] || 130
      @article_type   = options[:article_type]
      parse_style_name
      if @markup == 'br'
      else
        @tokens       = []
        create_tokens
      end
      @float_info = options[:float_info]
      create_para_lines if options[:create_para_lines]
      self
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

    # before we create any text_tokens,
    # check if we have any special token mark EMPASIS_STRONG or EMPASIS_DIAMOND
    # if EMPASIS_STRONG or EMPASIS_DIAMOND are found, split para string with EMPASIS_STRONG and EMPASIS_DIAMOND segments
    # and call create_plain_tokens for regular string segment
    def create_tokens
      if @markup == "h4" || @markup == "h1"
        # for author and linked to page, check if there is markup for moving up the text, if there is enoung text_area[2]
        if  @para_string =~/\s?\^\s?$/
          @para_string = @para_string.sub(/\s?\^\s?$/, "")
          @move_up_if_room = true
        end
      end
      if @para_string =~EMPASIS_STRONG
        create_tokens_with_emphasis_strong(@para_string)
      elsif @para_string =~EMPASIS_ARROW
        create_tokens_with_emphasis_arrow(@para_string)
      elsif @para_string =~EMPASIS_DIAMOND
        create_tokens_with_emphasis_diamond(@para_string)
      else
        create_plain_tokens(@para_string)
      end
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

    def create_plain_tokens(para_string)
      # parse for tab first
      return unless para_string
      tokens_strings = para_string.split(" ")
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
      tokens_strings.each do |token_string|
        next unless token_string
        token_options = {}
        token_options[:string]      = token_string
        token_options[:style_name]  = @style_name
        token_options[:para_style]  = @para_style
        token_options[:height]      = @para_style[:font_size]
        # if RUBY_ENGINE != "rubymotion"
        glyphs                     = @font_wrapper.decode_utf8(token_string)
        width= glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
        token_options[:width]      = width  
        # end
        @tokens << RLayout::RTextToken.new(token_options)
      end
    end

    def create_tokens_with_emphasis_strong(para_string)
      para_string.chomp!
      para_string.sub!(/^\s*/, "")
      split_array = para_string.split(EMPASIS_STRONG)
      # splited array contains strong content
      split_array.each do |token_group|
        if token_group =~EMPASIS_STRONG
          token_group.gsub!("**", "")
          # get font and size
          current_style = RLayout::StyleService.shared_style_service.current_style
          style_hash = current_style['body_gothic'] #'strong_emphasis'
          @emphasis_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
          @current_style_service = RLayout::StyleService.shared_style_service
          @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style              = {}
            emphasis_style[:string]     = token_string
            emphasis_style[:style_name] = 'body_gothic'
            emphasis_style[:para_style] = @emphasis_para_style
            emphasis_style[:height]     = @emphasis_para_style[:font_size]
            # if RUBY_ENGINE != "rubymotion"
              glyphs                     = @font_wrapper.decode_utf8(token_string)
              emphasis_style[:width]      = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
            # end
            @tokens << RLayout::RTextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          create_plain_tokens(token_group)
        end
      end
    end

    def create_tokens_with_emphasis_diamond(para_string)
      para_string.chomp!
      para_string.sub!(/^\s*/, "")
      split_array = para_string.split(EMPASIS_DIAMOND)
      # splited array contains strong content
      split_array.each do |token_group|
        if token_group =~EMPASIS_DIAMOND
          token_group.gsub!("*", "")
          # get font and size
          if token_group =~ /◆/
            token_group = token_group + "="
          else
            token_group.strip!
            token_group = "◆" + token_group + " ="
          end
          current_style = RLayout::StyleService.shared_style_service.current_style
          style_hash = current_style['body_gothic'] #'diamond_emphasis'
          @diamond_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
          @current_style_service = RLayout::StyleService.shared_style_service
          @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
          # @style_object = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style              = {}
            emphasis_style[:string]     = token_string
            emphasis_style[:style_name] = 'body_gothic'
            emphasis_style[:para_style] = @diamond_para_style
            emphasis_style[:height]     = @diamond_para_style[:font_size]
            emphasis_style[:token_type] = 'diamond_emphasis'
            # if RUBY_ENGINE != "rubymotion"
              glyphs                     = @font_wrapper.decode_utf8(token_string)
              emphasis_style[:width]      = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
            # end
            @tokens << RLayout::RTextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          # puts "token_group for plain: #{token_group}"
          create_plain_tokens(token_group)
        end
      end
    end

    def create_tokens_with_emphasis_arrow(para_string)
      para_string.chomp!
      para_string.sub!(/^\s*/, "")

      split_array = para_string.split(EMPASIS_DIAMOND)
      # splited array contains strong content
      split_array.each do |token_group|
        if token_group =~EMPASIS_ARROW
          token_group.gsub!("*▲", "")
          token_group.sub!("*", "")
          # get font and size
          unless token_group =~ />/
            token_group.strip!
            token_group = "▲" + token_group
          end
          # unless token_group =~ /\=/
          #   token_group.strip!
          #   token_group += " ="
          # end
          current_style = RLayout::StyleService.shared_style_service.current_style
          style_hash = current_style['body_gothic'] #'diamond_emphasis'
          @diamond_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
          @current_style_service = RLayout::StyleService.shared_style_service
          @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
          # @style_object = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style              = {}
            emphasis_style[:string]     = token_string
            emphasis_style[:style_name] = 'body_gothic'
            emphasis_style[:para_style] = @diamond_para_style
            emphasis_style[:height]     = @diamond_para_style[:font_size]
            emphasis_style[:token_type] = 'diamond_emphasis'
            if RUBY_ENGINE != "rubymotion"
              glyphs                     = @font_wrapper.decode_utf8(token_string)
              emphasis_style[:width]      = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
            end
            @tokens << RLayout::RTextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          # puts "token_group for plain: #{token_group}"
          create_plain_tokens(token_group)
        end
      end
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
      elsif @markup == 'h1' || @markup == 'h2' || @markup == 'h3' ||  @markup == 'h4'
        unless @current_line.first_text_line?
          if @para_style[:space_before_in_lines] == 1
            @current_line.layed_out_line = true
            unless @current_line.next_text_line
              @current_line = @current_line.parent.add_new_page if @current_line.parent.respond_to?(:add_new_page)
            end
            @current_line = @current_line.next_text_line
          end
          @current_line.layed_out_line = true
          @current_line.token_union_style = @token_union_style if @token_union_style
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
        # binding.pry if token.string == "“그리고요……”" #&& @current_line.first_text_line?
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
          end
        elsif result
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
            @current_line = @current_line.parent.add_new_page if @current_line.parent.respond_to?(:add_new_page)
            # tokens.unshift(token) #stick the unplace token back to the tokens_copy
            # break #reached end of column
          end
        end
      end
      if @line_count == 1 && @current_line.line_type == 'first_line'
        @current_line.text_alignment = 'left'
      else
        @current_line.set_paragraph_info(self, "last_line")
      end
      @current_line.align_tokens

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

    def parse_style_name
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

    # layout paragragraph
    def self.layout_paragraph(para_string, markup, column_width)
      p = RParagraph.new(para_string: para_string, markup: markup, line_width: column_width)
      p.create_para_lines(options)
      if options[:text_lines_array]
        # layout lines with given text_lines_array
      end
      p.para_lines
    end

    def create_para_lines
      return if tokens.length == 0
      @para_lines = []
      tokens_copy = tokens.dup
      @current_line = RLayout::RLineFragment.new(line_type: "first_line", width: @line_width)
      token = tokens_copy.shift
      if token && token.token_type == 'diamond_emphasis'
        @current_line.line_type = "middle_line"
      elsif @markup == 'h1' || @markup == 'h2' || @markup == 'h3' ||  @markup == 'h4'
        @current_line.token_union_style = @token_union_style if @token_union_style
        @current_line.line_type =  "middle_line"
      end

      while token
        result = @current_line.place_token(token)
        
        if result.class == RTextToken
          # token is broken into two, second part is returned
          @current_line.align_tokens
          @current_line.room = 0
          @current_line = RLayout::RLineFragment.new(line_type: "middle_line", width: @line_width)
          @para_lines << @current_line
          token = result          
        elsif result
          # puts "entire token placed succefully, returned result is true"
          token = tokens_copy.shift
        else
          # entire token was rejected,
          @current_line.align_tokens
          @current_line.room = 0
          @current_line = RLayout::RLineFragment.new(line_type: "middle_line", width: @line_width)
          @para_lines << @current_line
        end
        @para_lines
      end

      @current_line.align_tokens
      if @move_up_if_room 
        if found_previous_line = previous_line_has_room(@current_line)
          move_tokens_to_previous_line(@current_line, found_previous_line)
          @current_line.layed_out_line = false
          @current_line
        else
          @current_line.next_text_line
        end
      else
        @current_line.next_text_line
      end
    end

    def layout_para_lines_with_text_lines(text_lines_array)
      
    end

  end

end
