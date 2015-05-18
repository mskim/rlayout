module RLayout
  
  # TextLayoutRuby
  # 1. Parse marked up inline paragraph text into attributted string.
  # 2. Create Tokens for line layout
  # 3. layout line for the Paragraph.
  
  class TextLayoutRuby
    attr_accessor :owner_graphic, :tokens, :lines
    attr_accessor :string, :atts_run_array, :para_string
    attr_accessor :para_string, :para_style
    def initialize(owner_graphic, options={})
      @owner_graphic  = owner_graphic
      @tokens         = []
      @lines          = []
      @font           = "Times"
      @text_size           = 16
      if options[:para_string]
        @para_string = options[:para_string]
        para_string_to_atts_string_ruby
      elsif options[:atts_string_ruby]
        @atts_run_array  = options[:atts_string_ruby][:atts_run_array]
        @string     = options[:atts_string_ruby][:string]
      end
      create_tokens
      layout_text_lines
      self
    end    
    
    # atts_string_ruby is substitution for NSAttributtedString
    # it takes ParaString and converts into inline style stripped pure string, and series of atts_run_array
    # ParaString is text with markdown inline style markup _italic_ *for bold*
    # $$for inline math$$ 
    
    def para_string_to_atts_string_ruby
      # create string
      # create @atts_run
      @string = @para_string
      @atts_run_array = []
      # AttsRunStruct = Struct.new(:position, :length, :size, :color, :font, :style) do
      first_att = AttsRunStruct.new(0,@string.length, 16, "black", 'Times', "plain")
      @atts_run_array << first_att
    end
    
    # for archiving
    # save string and atts_run_array as "atts_string_ruby" (Not NSAttributtedString)
    def to_atts_string_ruby
      # atts_string_ruby has :string and :atts_run_array
      h = {}
      h[:string] = @string
      h[:atts_run_array] = @atts_run_array.map {|run| run.to_hash}
      h
    end
    
    def create_tokens
      font_object  = RFont.new(@font, @text_size)
      @token_space  = font_object.space_char_width
      @tokens = @string.split(" ").collect do |token_string|
        size  = font_object.string_size(token_string)
        @line_height   = @text_size + @top_margin + @bottom_margin
        TextToken.new(nil, :string=>token_string, :width=>size[0], :height=>@line_height, :layout_expand=>[], :font=>@font, :text_size=>@text_size) #, :line_width=>1, :line_color=>'green'
      end
    end
      
    def layout_text_lines(options={})
    
    end
  end
    
  class TextToken
    attr_accessor :position, :length, :x, :y, :width, :height, :string, :style
    def initialize(position, length, options={})
      
      self
    end
  end
  
  class LineFragment 
    attr_accessor :starting_index, :ending_index
    attr_accessor :x, :y, :width, :height, :space_width
    def initialize(starting_index, options={})
      @space_width    = options[:space_width]
      @staring_index  = starting_index
      self
    end
    
    def layout_lines_starting_at(tokens_index)
      current_index   = tokens_index
      @starting_index = current_index
      current_x       = @x
      current_run     = @text_runs[current_index]
      
      while current_index < @text_runs.length  && current_x < @width do
        if current_run.width + current_x <= width
          current_run.x = @x
          current_index += 1
          current_x     += current_run.width + @space_width
        else
          break
        end
      end
      current_index
    end
  end
  
end
