
# TextToken
# TextToken consists of text string with uniform attributes, a same text run.
# TextToken does not contain space character. Space charcter is implemented as gap between tokens.

# TextTokens with graphic attributes
# TextTokens can have graphic attributes, such as  Box, Round, Colored,
# text{options}
# boxed_text{stroke_width: 0.5}
# rounded_text{stroke_width: 0.5, shape: "round"}

# Special Tokens
# Special Tokens are those tokens with complex shapes or special text effects,
# such as Ruby, ReversedRuby, InlineMultipleChoice ...
# Special tokens are created from markup,
# markup has form of  {{def_name 'first', 'second', options={})}}

# Special token styles can be pre-defined and can be assigned at run time.
# This make it convient to switch from one design to other.
# @ruby_style     = {
#   top_color: 'red'
#   top_align: 'center'
#   top_size:  '20%'
# }
# @ruby_style1    ={}
# @undertag_style ={
#   under_line_color: 'black'
#   under_text_color: 'gray'
#   under_align: 'center'
#   under_size:  '80%'
# }
# @choice_style   ={
#   number_type: 'numeric'
#   number_effect: 'circle'
#   chioce_style: 'underline'
# }
#

# LatexToken
#
#

QUOTE_PLAIN_SINGLE         = 39
QUOTE_PLAIN_DOUBLE         = 34
QUOTE_SMART_SINGLE_OPEN    = 8216
QUOTE_SMART_SINGLE_CLOSE   = 8217
QUOTE_SMART_DOUBLE_OPEN    = 8220
QUOTE_SMART_DOUBLE_CLOSE   = 8221

module RLayout
  # token fill_color is set by optins[:token_color] or it is set to clear

  class TextToken < Graphic
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    attr_accessor :string, :atts, :stroke, :has_text, :token_type # number, empasis, special
    attr_reader :split_second_half_attsting

    def initialize(options={})
      @string                   = options[:string]
      options[:layout_expand]   = nil
      @has_text                 = true
      if RUBY_ENGINE == "rubymotion"
        if options[:atts]
          @atts = options[:atts]
        else
          @atts       = default_atts
        end

        if options[:att_string]
          @attrs        = options[:atts] #TODO?
          @att_string   = options[:att_string]
          @string       = @att_string.string if @att_string.class == NSConcreteMutableAttributedString # if @att_string.respond_to?(:string)
          options[:height]= @att_string.size.height*1.2
        else
          @att_string     = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
          options[:width] = @att_string.size.width
          options[:height]= @att_string.size.height*1.2
        end
      else
        # TODO fix get string with from Rfont
        font_size = options[:font_size] || 10
        size = RFont.string_size(@string, options[:font], font_size)
        options[:width]  = size[0]
        options[:height] = size[1]
      end
      options[:fill_color] = options.fetch(:token_color, 'clear')
      super
      if RUBY_ENGINE == "rubymotion"
        # add some margin to left and right of the token.
        @width  = @att_string.size.width + @left_margin + @right_margin
        @x      = @left_margin
        #TODO fix this
        if options[:text_line_spacing] && options[:text_line_spacing].class != String
          @height += options[:text_line_spacing]
        else
          # @height += 10
        end
      end
      self
    end

    def tracking_count
      return 0 unless @string
      @string.length - 1
    end

    # reduce the tracking value of token by 10%
    def reduce_tracking_value(tracking_value)
      if RUBY_ENGINE == "rubymotion"
        font_size   = @atts[NSFontAttributeName].pointSize
        delta       = font_size/10
        @atts[NSKernAttributeName] = -tracking_value
        @att_string     = NSAttributedString.alloc.initWithString(@string, attributes: @atts)
        @width = @att_string.size.width
      else
        font_size   = @atts[:font_size]
        delta       = font_size/10
        @para_style[:tracking] -= delta
      end
      self
    end


    # return false if none broken
    # split string into two and pit split_second_half_attsting
    def break_attstring_at(break_position)
      # give a char_half_cushion
      return false if break_position < MinimunLineRoom
      string_length = @att_string.length
      if RUBY_ENGINE == "rubymotion"
        initial_range = NSMakeRange(0,1)
        sub_string_before = @att_string.attributedSubstringFromRange(initial_range)
        (1..string_length).to_a.each do |i|
          front_range = NSMakeRange(0,i)
          sub_string_after = @att_string.attributedSubstringFromRange(front_range)
          if i == string_length && sub_string_after.string =~ /\.$/
            return "period at the end of token"
          elsif sub_string_after.size.width > (break_position + CharHalfWidthCushion)
            #TODO handle . , line ending rule. procenting orphan
            cut_index = i - 1 # pne before i
            back_range = NSMakeRange(cut_index,(string_length - cut_index))
            original_string = @att_string
            @att_string = sub_string_before
            @string     = @att_string.string
            @width      = @att_string.size.width + @left_margin + @right_margin
            new_string  = original_string.attributedSubstringFromRange(back_range)
            return new_string
          else
            sub_string_before = sub_string_after
          end
        end
        return false

      end

    end

    # divide token at position
    def hyphenate_token(break_position)
      position = break_position
      if RUBY_ENGINE == "rubymotion"
        # break_attstring_at breaks original att_string into two
        # adjust first token width and result is second haldf att_string
        # or false is return if not abtle to brake the token
        result = break_attstring_at(position)
        if result == "period at the end of token"
          return "period at the end of token"
        elsif result.class == NSConcreteMutableAttributedString
          second_half = self.dup
          second_half.att_string = result
          second_half.width = result.size.width + @left_margin + @right_margin
          return second_half
          # return TextToken.new(att_string: result, atts: @atts)
        else
          return false
        end
      else
      end
      false
    end

    def size
      @att_string.size
    end

    def origin
      NSMakePoint(@x,@y)
    end

    def svg
      # TODO <text font-size=\"#{font_size}\"
      s = ""
      if string !=nil && string != ""
        s += "<text font-size=\"#{@font_size}\" x=\"#{x}\" y=\"#{y + height*0.8}\">#{string}</text>\n"
      end
      s
    end

    def default_atts
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end

    # TextToken don't have TextLayoutManager, they just have @att_string
    def draw_text
      # drawing view origin is at @x,@y
      @att_string.drawAtPoint(NSMakePoint(@left_margin,0))
    end

    def get_stroke_rect
      if RUBY_ENGINE == "rubymotion"
        stroke_width = @att_string.size.width + @left_margin + @right_margin
        # for TextToken, use attstring rect instead of Graphic frame
        r = NSMakeRect(0,0,stroke_width, @att_string.size.height)
        r = NSInsetRect(r, -1, -1)
        if @line_position == 1 #LINE_POSITION_MIDDLE
          return r
        elsif @line_position == 2
          #LINE_POSITION_OUTSIDE)
          return NSInsetRect(r, - @stroke[:thickness]/2.0, - @stroke[:thickness]/2.0)
        else
          # LINE_POSITION_INSIDE
          return NSInsetRect(r, @stroke[:thickness]/2.0, @stroke[:thickness]/2.0)
        end
      else
        puts "get_stroke_rect for ruby mode"
      end
    end
  end

  # TextCell is used to set alignment for TextToken is a cell
  class TextCell < Container
    attr_accessor :h_alignment, :v_alignment, :token
    attr_accessor :insert_leader_token, :atts
    def initialize(options={})
      super
      @layout_direction = "horizontal"
      @token          = options[:token]
      @atts           = options[:atts]
      @insert_leader_token = options.fetch(:insert_leader_token, false)
      @layout_length  = @width
      @h_alignment    = options.fetch(:h_alignment, "left")
      @v_alignment    = options.fetch(:v_alignment, "top")
      @height         = @token.height
      @token.parent_graphic = self
      @graphics << token
      align_token
      self
    end

    def align_token
      @margin = 2
      @space = @width - @token.width - @margin*2
      if @space <= @margin
        @x = 0
        return
      end

      case @h_alignment
      when 'left'
        @token.x = @margin
        if @insert_leader_token
          LeaderToken.new(parent: self, x: @margin + @token.width, width: @space, atts: @atts)
        end
      when 'center'
        @token.x = @margin + @space/2
      when 'right'
        @token.x = @margin + @space
        if @insert_leader_token
          LeaderToken.new(parent: self, x: @margin, width: @space, atts: @atts)
          @graphics.reverse!
        end
      else
        @token.x = @margin
      end

    end
  end

  #number,
  #lower_alphabet,
  #lower_alphabet,
  #roman,
  #korean_radical,
  #koreand_ga_na_da
  class NumberToken < TextToken
    attr_accessor :number_type

    def initialize(options={})
      # TODO i should refactor this using /^list_/
      if RUBY_ENGINE == 'rubymotion'
        options[:atts] = ns_atts_from_style(options)
      end
      super

      self
    end
  end

  # TabToken servers as place holder
  class TabToken < Graphic
    attr_accessor :tab_type  #left, right, center, decimal
    def initialize(options={})
      super
      @tab_type = "left"
      @width    = options.fetch(:width, 20)
      self
    end
  end

  # LeaderToken fills the gap with leader chars
  class LeaderToken < Graphic
    attr_accessor :leader_char, :string, :has_text
    def initialize(options={})
      options[:layout_expand]   = nil
      @leader_char  = options.fetch(:leader_char,'.')
      super
      @has_text     = true
      @string       = "."
      @margin       = 2
      if RUBY_ENGINE == "rubymotion"
        if options[:atts]
          puts "options[:atts]['NSFont'].pointSize"
          @atts     = options[:atts]
        else
          puts "using default_atts"
          @atts     = default_atts
        end
        @att_string = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
        count       = ((@width - @margin*2)/@att_string.size.width).to_i
        @string     *=count
        @att_string = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
      else
        # TODO fix get string with from Rfont
      end
      @height = 20
      self
    end

    def default_atts
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end

    def draw_text
      @att_string.drawAtPoint(NSMakePoint(0,0))
    end
  end

  class ImageToken < Graphic
    attr_accessor :image_path, :x,:y, :width, :height, :image_path
    def initialize(options={})
      image_name            = options[:image_name]
      image_folder          = "/Users/Shared/SoftwareLab/image_icon"
      image_path  = Dir.glob("#{image_folder}/#{image_name}.*").first
      unless image_path
        image_path = image_folder + "/#{image_name}.pdf"
      end
      options[:image_path] = image_path
      #TODO fix this!!!
      options[:y]           = 3
      options[:width]       = 20
      options[:height]      = 9
      options[:image_record]= ImageStruct.new(options[:image_path])
      super
      self
    end
  end

  class SubscriptToken < TextToken
    # reduce size and shift y position
    # options[:atts]
    def initialize(options={})

    end
  end

  class SubperscriptToken < TextToken
    # reduce size and shift y position
    def initialize(options={})

    end
  end

  # Special Tokens
  # Special Tokens are those tokens with complex shapes or special text effects,
  # such as Ruby, ReversedRuby, InlineMultipleChoice ...
  # Special tokens are created from markup,
  # markup has form of  {{def_name 'first', 'second', options={})}}
  # markup has form of  {{ruby 'base', 'top', options={})}}
  class RubyToken < Container
    attr_accessor :base_tokeb, :top_token, :size_ratio
    def initialize(options={})
      super
      @size_ratio         = options.fetch(:size_ratio, 0.5)
      base_style          = options[:para_style]
      base_style[:string] = options[:base]
      base_style[:parent] = self
      base_style[:tag]    = "base"
      @base_token         = TextToken.new(base_style)
      # make the top_token with size 0.5 text
      top_style           = options[:para_style]
      top_style[:font_size]= top_style[:font_size]*@size_ratio
      top_style[:string]  = options[:top]
      top_style[:parent]  = self
      top_style[:tag]        = "top"
      @top_token          = TextToken.new(top_style)
      @graphics.reverse
      # increase the height by 0.5
      relayout!
      self
    end
  end

  # markup has form of  {{r-ruby 'base', 'bottom', options={})}}
  class ReverseRubyToken < Container
    attr_accessor :base_token, :bottom_token, :size_ratio, :base_style, :bottom_style
    def initialize(options={})
      options[:fill_color] = "clear"
      super
      # make the top_token with size 0.5 text
      @size_ratio         = options.fetch(:size_ratio, 0.5)
      @base_style          = options[:para_style].dup
      @bottom_style        = options[:para_style].dup

      @base_style[:string] = options[:base]
      @base_style[:parent] = self
      if RUBY_ENGINE == "rubymotion"
        @base_style[:atts][NSForegroundColorAttributeName]  =  NSColor.blackColor
      else
        @base_style[:text_color]= "blue"
      end

      @base_style[:tag]    = "base"
      @base_style[:stroke_sides]    = [0,0,0,1]
      @base_style[:stroke_color]    = "blue"
      @base_style[:stroke_width]    = 0.5
      @base_token             = TextToken.new(@base_style)
      @bottom_style[:font_size]= @base_style[:font_size]*@size_ratio
      # if RUBY_ENGINE == "rubymotion"
      #   @bottom_style[:atts][NSForegroundColorAttributeName]  =  NSColor.blueColor
      # else
      #   @bottom_style[:text_color]= "blue"
      # end
      @bottom_style[:string]   = options[:bottom]
      @bottom_style[:parent]   = self
      @bottom_style[:width]    = @base_token.width
      @bottom_style[:height]   = 10
      @bottom_style[:text_alignment] = "center"
      @bottom_style[:tag]      = "bottom"
      @bottom_style[:x]        = (@base_token.width - 5)/2.0
      @bottom_style[:y]        = 12
      @bottom_style[:fill_color]= 'clear'
      @bottom_token            = TextToken.new(@bottom_style)
      # token = TextToken.new(string: item, atts: @table_head_style, layout_expand: :width)
      TextCell.new(parent: self, width: @base_token.width, height: @bottom_style[:height], token: @bottom_token, h_alignment: "center", atts: @bottom_style, fill_color: 'clear')

      @height                  = 25
      @width                   = @base_token.width
      # relayout!
      self
    end
  end


end
