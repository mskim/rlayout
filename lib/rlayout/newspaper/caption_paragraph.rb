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

      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object = @current_style_service.style_object('caption_title')
      @tokens += @caption_title.split(" ").collect do |token_string|
        options = {}
        options[:string]      = token_string
        options[:height]      = @style_object.font_size
        options[:style_object] = @style_object
        RLayout::RTextToken.new(options)
      end
    end

    def make_caption_tokens
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object = @current_style_service.style_object('caption')
      @tokens += @caption.split(" ").collect do |token_string|
        options = {}
        options[:string]      = token_string
        options[:height]      = @style_object.font_size
        options[:style_object] = @style_object
        RLayout::RTextToken.new(options)
      end
    end

    def make_source_tokens
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object = @current_style_service.style_object('source')
      @source_tokens  += @source.split(" ").collect do |token_string|
        options = {}
        options[:string]      = token_string
        options[:height]      = @style_object.font_size
        options[:style_object] = @style_object
        RLayout::RTextToken.new(options)    
      end
    end

    # layout_lines is called from news_image
    # after creating caption_column and CaptionParagraph
    def layout_lines(caption_column)
      @current_line               = caption_column.graphics.first
      @current_line.style_name    = 'caption'
      @current_line.space_width   = @space_width
      @current_line.text_alignment = 'justify'
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
          @current_line.text_alignment = 'justify'
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
          @current_line.text_alignment  = 'justify'
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
