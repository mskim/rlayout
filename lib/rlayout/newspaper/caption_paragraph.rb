module RLayout
  class CaptionParagraph
    attr_accessor :caption_title, :caption, :source
    attr_accessor :tokens, :source_tokens, :current_style, :para_style
    attr_accessor :space_width
    def initialize(options={})
      @caption_title  = options[:caption_title]
      @caption        = options[:caption]
      @source         = options[:source]
      @tokens         = []
      @source_tokens  = []
      @current_style  = RLayout::StyleService.shared_style_service.current_style
      create_tokens
      self
    end

    def create_tokens
      make_caption_title_tokens if @caption_title
      make_caption_tokens       if @caption
      make_source_tokens        if @source
    end

    def make_caption_title_tokens
      @style_name           = 'caption_title'
      @caption_title_style  = @current_style[@style_name]
      @para_style           = Hash[@caption_title_style.map{ |k, v| [k.to_sym, v] }]
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
      @tokens += @caption_title.split(" ").collect do |token_string|
        options = {}
        options[:para_style]  = @para_style
        options[:style_name]  = @style_name
        options[:string]      = token_string
        if RUBY_ENGINE != 'rubymotion'
          glyphs                = @font_wrapper.decode_utf8(token_string)
          width                 = glyphs.map { |g| @style_object.scaled_item_width(g)}.reduce(:+)
          options[:width]       = width  
        end
        options[:height]      = para_style[:font_size]
        RLayout::RTextToken.new(options)
      end
    end

    def make_caption_tokens
      @style_name           = 'caption'
      @caption_style        = @current_style[@style_name]
      @para_style           = Hash[@caption_style.map{ |k, v| [k.to_sym, v] }]
      @space_width          = @caption_title_style['space_width']
      if @space_width.nil?
        font_size   = @caption_style['font_size']
        @space_width = font_size/2
        @space_width = @space_width
      end
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
      @tokens += @caption.split(" ").collect do |token_string|
        options = {}
        options[:para_style]  = @para_style
        options[:style_name]  = @style_name
        options[:string]      = token_string
        if RUBY_ENGINE != 'rubymotion'
          glyphs                = @font_wrapper.decode_utf8(token_string)
          width                 = glyphs.map { |g| @style_object.scaled_item_width(g)}.reduce(:+)
          options[:width]       = width  
        end
        options[:height]      = para_style[:font_size]
        RLayout::RTextToken.new(options)
      end
    end

    def make_source_tokens
      @style_name             = 'source'
      @source_style           = @current_style[@style_name]
      @para_style             = Hash[@source_style.map{ |k, v| [k.to_sym, v] }]
      @current_style_service  = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper = @current_style_service.style_object(@style_name) if RUBY_ENGINE != "rubymotion"
      @source_tokens  += @source.split(" ").collect do |token_string|
        options = {}
        options[:para_style]  = @para_style
        options[:style_name]  = @style_name
        options[:string]      = token_string
        if RUBY_ENGINE != 'rubymotion'
          glyphs                = @font_wrapper.decode_utf8(token_string)
          width                 = glyphs.map { |g| @style_object.scaled_item_width(g)}.reduce(:+)
          options[:width]       = width  
        end
        options[:height]      = para_style[:font_size]
        RLayout::RTextToken.new(options)    
      end
    end

    # layout_lines is called from news_image
    # after creating caption_column and CaptionParagraph
    def layout_lines(caption_column)
      @current_line               = caption_column.graphics.first
      @current_line.style_name    = 'caption'
      @current_line.space_width   = @space_width
      @current_line.text_alignment = 'justified'
      @current_line.room          = @current_line.width
      token = @tokens.shift
      while token
        result = @current_line.place_token(token)
        # result can be one of tree
        # case 1. token is broken into two, second part is returned
        # case 2. entire token placed succefully, returned result is true
        # case 3. entire token is rejected from the line
        if result.class == RTextToken # case 1
          @current_line.align_tokens
          @current_line = caption_column.add_new_line
          @current_line.text_alignment = 'justified'
          @current_line.place_token(result)
          token = tokens.shift
        elsif result # case 2
          # entire token placed succefully, returned result is true
          token = tokens.shift
        else  # case 3
          # entire token was rejected,
          @current_line.align_tokens
          @current_line                 = caption_column.add_new_line
          @current_line.style_name      = 'caption'
          @current_line.text_alignment  = 'justified'
          @current_line.place_token(token)
          token = tokens.shift
        end
      end
      @current_line.text_alignment = 'left' # align left for last line
      @current_line.align_tokens
      if @source && @source != ""
        line_width                = @current_line.width
        token_list                = @current_line.graphics
        source_tokens_space_sum   = (@source_tokens.length - 1)*@space_width
        source_tokens_width_sum   = @source_tokens.map{|x| x.width}.reduce(0, :+)
        source_tokens_area_width  = source_tokens_width_sum + source_tokens_space_sum
        source_starting_x         = line_width - source_tokens_area_width #+ @space_width
        end_of_tokens             = 0
        end_of_tokens             = token_list.last.x_max if token_list.length > 0
        if (end_of_tokens + @space_width) < source_starting_x
          x = source_starting_x
          @source_tokens.each do |source_token|
            source_token.parent = @current_line
            source_token.x = x
            token_list << source_token
            x              += source_token.width + @space_width
            source_token.y = 0
          end

        else
          # create one more line
          @current_line = caption_column.add_new_line
          # caption_column.add_new_line
          x = source_starting_x #+ @space_width
          @source_tokens.each do |source_token|
            # source_token.parent = self
            source_token.x = x
            source_token.y = 0
            @current_line.place_token(source_token)
            x += source_token.width + @space_width
          end
        end
      end
    end

  end


end
