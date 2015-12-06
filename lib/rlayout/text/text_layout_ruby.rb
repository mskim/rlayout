module RLayout
  
  # RTextLayoutManager
  # TextLayoutManager in Ruby
  # 1. Parse marked up inline paragraph text into attributted string.
  # 2. Create Tokens for line layout
  # 3. layout line for the Paragraph.
  

  # class Token
  #   attr_accessor :line_framgment, :type
  #   attr_accessor :position, :length, :x, :y, :width, :height, :string, :style
  #   def initialize(line_framgment, options={})
  #     @line_framgment     = line_framgment
  #     @position           = options.fetch(:position, 0)
  #     @length             = options.fetch(:position, 0.0)
  #     self
  #   end
  # end
  # 
  # class TextToken < Token
  #   def initialize(line_framgment, options={})
  #     super
  #     @type               = options.fetch(:type, "text")
  #     self
  #   end
  # end
  # 
  # class MathToken < Token
  #   def initialize(line_framgment, options={})
  #     super
  #     @type               = options.fetch(:type, "math")
  #     self   
  #   end 
  # end
  # 
  # class ImageToken < Token
  #   def initialize(line_framgment, options={})
  #     super
  #     @type               = options.fetch(:type, "image")
  #     self   
  #   end 
  # end
  # 
  # class LineFragment 
  #   attr_accessor :position, :length
  #   attr_accessor :x, :y, :width, :height, :space_width
  #   def initialize(layout_manager, options={})
  #     @space_width    = options[:space_width]
  #     @position       = options.fetch(:position, 0)
  #     self
  #   end
  #   
  #   def layout_lines_starting_at(tokens_index)
  #     current_index   = tokens_index
  #     @position = current_index
  #     current_x       = @x
  #     current_run     = @text_runs[current_index]
  #     
  #     while current_index < @text_runs.length  && current_x < @width do
  #       if current_run.width + current_x <= width
  #         current_run.x = @x
  #         current_index += 1
  #         current_x     += current_run.width + @space_width
  #       else
  #         break
  #       end
  #     end
  #     current_index
  #   end
  # end
  # 
end
