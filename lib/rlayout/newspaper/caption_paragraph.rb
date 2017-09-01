module RLayout
  class CaptionParagraph
    attr_accessor :caption_title, :caption, :source
    attr_accessor :tokens, :source_tokens
    attr_accessor :caption_title_space_width, :caption_space_width, :source_space_width

    def initialize(options={})
      @caption_title  = options[:caption_title]
      @caption        = options[:caption]
      @source         = options[:source]
      @tokens         = []
      @source_tokens  = []
      create_tokens
      self
    end

    def create_tokens
      make_caption_title_tokens if @caption_title
      make_caption_tokens       if @caption
      make_source_tokens        if @source
    end


    def make_caption_title_tokens
      atts                          = NEWSPAPER_STYLE['caption_title']
      atts                          = Hash[atts.map{ |k, v| [k.to_sym, v] }]
      @caption_title_space_width    = atts[:space_width] || atts[:font_size]/2
      @tokens += @caption_title.split(" ").collect do |token_string|
        options = {}
        options[:string] = token_string
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = ns_atts_from_style(atts)
        end
        RLayout::TextToken.new(options)
      end

    end


    def ns_atts_from_style(style)
      atts = {}
      atts[NSFontAttributeName] = NSFont.fontWithName("Times", size:10.0)
      if style[:font] && style[:font_size]
        atts[NSFontAttributeName] = NSFont.fontWithName(style[:font], size: style[:font_size])
      end
      if style[:text_color]
        if style[:text_color] == ""
          atts[NSForegroundColorAttributeName] = NSColor.blackColor
        else
          atts[NSForegroundColorAttributeName] = RLayout.color_from_string(style[:text_color])
        end
      end

      #TODO tracking, scale, space_width
      atts
    end

    def make_caption_tokens
      atts                          = NEWSPAPER_STYLE['caption']
      atts                          = Hash[atts.map{ |k, v| [k.to_sym, v] }]
      @caption_space_width          = atts[:space_width] || 3
      @tokens += @caption.split(" ").collect do |token_string|
        options = {}
        options[:string]  = token_string
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = ns_atts_from_style(atts)
        end
        RLayout::TextToken.new(options)
      end
    end

    def make_source_tokens
      atts                          = NEWSPAPER_STYLE['source']
      atts                          = Hash[atts.map{ |k, v| [k.to_sym, v] }]
      @source_space_width           = atts[:space_width] || atts[:font_size]/2
      @source_tokens += @source.split(" ").collect do |token_string|
        options = {}
        options[:string]  = token_string
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = ns_atts_from_style(atts)
        end
        RLayout::TextToken.new(options)
      end
    end

    # layout_lines is called from news_image
    # after creating caption_column and CaptionParagraph
    def layout_lines(caption_column)
      @current_line = caption_column.graphics.first
      token = @tokens.shift
      while token
        result = @current_line.place_token(token)
        # result can be one of tree
        # case 1. token is broken into two, second part is returned
        # case 2. entire token placed succefully, returned result is true
        # case 3. entire token is rejected from the line

        if result.class == TextToken # case 1
          @current_line.align_tokens
          @current_line = caption_column.add_new_line
          @current_line.place_token(result)
          token = tokens.shift
        elsif result # case 2
          # entire token placed succefully, returned result is true
          token = tokens.shift
        else  # case 3
          # entire token was rejected,
          @current_line.align_tokens
          @current_line = caption_column.add_new_line
          @current_line.place_token(token)
          token = tokens.shift
        end
      end
      @current_line.align_tokens
      if @source
        line_width                = @current_line.width
        token_list                = @current_line.graphics
        source_tokens_space_sum   = @source_tokens.length*@source_space_width
        source_tokens_width_sum   = @source_tokens.map{|x| x.width}.reduce(:+)
        source_tokens_area_width  = source_tokens_width_sum + source_tokens_space_sum + 2
        source_starting_x         = line_width - source_tokens_area_width + @source_space_width
        end_of_tokens             = token_list.last.x_max
        token_list.last.x_max
        if (end_of_tokens + @source_space_width) < source_starting_x
          x = source_starting_x
          @source_tokens.each do |source_token|
            source_token.parent_graphic = self
            source_token.x = x
            token_list << source_token
            x              += source_token.width + @source_space_width
            source_token.y = 0
          end

        else
          # create one more line
          add_new_line
          x = source_starting_x + @source_space_width
          @source_tokens.each do |source_token|
            source_token.parent_graphic = self
            source_token.x = x
            token_list << source_token
            x              += source_token.width + @source_space_width
            source_token.y = 0
          end
        end
      end

    end

  end


end
