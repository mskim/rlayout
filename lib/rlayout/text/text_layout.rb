module RLayout


  # TextLayout: CTFrame Ruby clone
  class TextFrame
  	attr_accessor :att_string, :lines, :runs, :uni_attribure
    attr_accessor :text_containers
    attr_accessor :line_direction #right_to_left, top_to_bottom

    def initialize(att_string, text_containers, options={})
      @att_string                 = att_string
      @text_containers            = text_containers
      @line_direction             = options.fetch(:line_direction, 'top_to_bottom')
      layout(options)
      self
    end

    def layout(options={})
      @runs   ||= []
      @lines  ||= []

      make_runs
      make_lines
    end

    # returns the range of characters that actually fit in the frame
    def fitting_string_range

    end

    def draw

    end

    private
    # create RTRuns from att_string
    def make_runs

    end

    # TextToken and TextRun
    # TextToken is line layout unit, it can contain single or mulitole runs
    # TextRun containes run of uniform attributes.

    def create_tokens
      font_object  = RFont.new(@font, @text_size)
      @token_space  = font_object.space_char_width
      @tokens = @para_string.split(" ").collect do |token_string|
        size  = font_object.string_size(token_string)
        @line_height   = @text_size*1.2 + @top_margin + @bottom_margin
        TextToken.new(nil, :text_string=>token_string, :width=>size[0], :height=>@line_height, :layout_expand=>[], :font=>@font, :text_size=>@text_size) #, :line_width=>1, :line_color=>'green'
      end
    end

    # create RTLines from RTRuns
    def make_lines

    end

  end

  # CTLine Ruby clone
  class TextLine

    def to_svg

    end

    def draw_line

    end

  end

  # CTRun Ruby clone
  class TextRun
    attr_accessor :att_string, :range, :glyphs
    attr_accessor :direction #vertical, horizontal

    def initialize(att_string, range, options={})
      @att_string = att_string
      @range      = range
      @direction  = options.fetch(:direction, 'horizontal')
      self
    end

    def run_rect

    end

    def to_svg

    end

    def draw_run

    end
  end

end
