
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
module RLayout
  # token fill_color is set by optins[:token_color] or it is set to clear
  
  class TextToken < Graphic
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    attr_accessor :string, :atts, :stroke, :has_text, :token_type # number, empasis, special
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

        @att_string     = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
        options[:width] = @att_string.size.width
        options[:height]= @att_string.size.height*2
      else
        # TODO fix get string with from Rfont
        @width  = 30
        @height = 20
      end
      options[:fill_color] = options.fetch(:token_color, 'clear')
      # options[:stroke_width] = 1
      super
      if RUBY_ENGINE == "rubymotion"
        # add give some space to left and right of the token if we are boxing it.
        @width  = @att_string.size.width + @left_margin + @right_margin
        @x      = @left_margin
        @height = @att_string.size.height
        if options[:text_line_spacing]
          @height += options[:text_line_spacing] 
        else
          @height += 10
        end
      end
      self
    end
    
    def size
      @att_string.size
    end
    
    def origin
      NSMakePoint(@x,@y)
    end
            
    def svg
      # TODO <text font-size=\"#{text_size}\"
      s = ""
      if string !=nil && string != ""
        s += "<text font-size=\"#{@text_size}\" x=\"#{x}\" y=\"#{y + height*0.8}\">#{string}</text>\n"
      end
      s
    end
    
    def ns_atts_from_style
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end
    
    def default_atts
      #TODO add color
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end
    
    # TextToken don't have TextLayoutManager, they just have @att_string
    def draw_text
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
  
  #number, 
  #lower_alphabet, 
  #lower_alphabet, 
  #roman, 
  #korean_radical, 
  #koreand_ga_na_da
  class NumberToken < TextToken
    attr_accessor :number_type  
    
    def initialize(options={})
      options[:font]          = options[:list_font] if options[:list_font]
      options[:text_size]     = options[:list_text_size] if options[:list_text_size]
      options[:text_color]    = options[:list_text_color] if options[:list_text_color]
      options[:fill_color]    = options[:list_fill_color] if options[:list_fill_color]
      options[:stroke_width]  = options[:list_stroke_width] if options[:list_stroke_width]
      options[:stroke_color]  = options[:list_stroke_color] if options[:list_stroke_color]
      # TODO i should refactor this using /^list_/
      super
      
      self
    end
    
    
  end
  
  class TabToken < Graphic
    attr_accessor :tab_type  #left, right, center, decimal
    def initialize(options={})
      super
      @tab_type = "left"
      @width    = 20
      self
    end
  end
  
  # LeaderToken fills the gap with leader chars
  class LeaderToken < Graphic
    attr_accessor :leader_char, :string, :has_text
    def initialize(options={}) 
      options[:layout_expand]   = nil
      @leader_char  = options.fetch(:leader_char,'.')
      # @string       = @leader_char
      super
      @has_text     = true
      @string       = "."
      @margin        = 2
      if RUBY_ENGINE == "rubymotion"
        if options[:atts]
          @atts       = options[:atts] 
        else
          @atts       = default_atts
        end
        @att_string = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
        count       = ((@width - @margin*2)/@att_string.size.width).to_i
        @string *=count
        @att_string = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
      else
        # TODO fix get string with from Rfont
        @width  = 30
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
    def initialize(image_path, options={})
      @image_path = image_path
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
      top_style[:text_size]= top_style[:text_size]*@size_ratio
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
      @bottom_style[:text_size]= @base_style[:text_size]*@size_ratio
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
      @bottom_token            = TextToken.new(@bottom_style)
      @height = 25
      @width = @base_token.width
      # relayout!
      self
    end
  end
  

end