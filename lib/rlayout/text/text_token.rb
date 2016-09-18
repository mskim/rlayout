
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
# such as Ruby, UnderlineTag, InlineMultipleChoice ...
# Special tokens are created from markup,
# markup has form of  def_name('first', 'second', options={}).

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
  
  class TextToken < Graphic
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    attr_accessor :string, :atts, :stroke, :has_text
    def initialize(options={})
      @string                   = options[:string]
      options[:layout_expand]   = nil
      @has_text                 = true
      if RUBY_ENGINE == "rubymotion"
        @atts           = default_atts
        @atts           = @atts.merge(options[:atts]) if options[:atts]
        @att_string     = NSAttributedString.alloc.initWithString(@string, attributes: options[:atts])
        options[:width] = @att_string.size.width
      else
        # TODO fix get string with from Rfont
        @width  = 30
      end
      super
      @x      = 0
      @y      = 0
      @height = 20
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
    
    def default_atts
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end
    
    # TextToken don't have TextLayoutManager, they just have @att_string
    def draw_text
      @att_string.drawAtPoint(NSMakePoint(0,0))
    end
    
    # TODO use graphic draw by redefineing getLineRect for different class
    # draw TextToken stroke 
    def draw_stroke
      if RUBY_ENGINE == "rubymotion"
        rect = NSMakeRect(0,0,@att_string.size.width, @att_string.size.height)
        rect = NSInsetRect(rect, -1, -1)
        path = NSBezierPath.bezierPathWithRect(rect)
        path.setLineWidth(@stroke[:thickness])
        path.stroke 
      else
        puts "draw_stroke in Ruby mode"
      end
    end
    
    def get_stroke_rect
      if RUBY_ENGINE == "rubymotion"
        # for TextToken, use attstring rect instead of Graphic frame
        r = NSMakeRect(0,0,@att_string.size.width, @att_string.size.height)
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
        @atts       = default_atts
        @atts       = @atts.merge(options[:atts]) if options[:atts]
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

  
  class RubyToken < Container
    attr_accessor :base_token, :top_token
    def initalize(options={})
      
      self
    end
  end
  
  class UndertagToken < Container
    attr_accessor :base_token, :bottom_token
    
    def initalize(options={})
      
      self
    end
  end
  
  
end