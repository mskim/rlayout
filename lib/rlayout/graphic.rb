require 'json'
# PageScript Verbs
#  rect
#  circle
#  round_rect

#  line_type=

module RLayout
  
  class Graphic
    attr_accessor :parent_graphic, :klass, :tag
    attr_accessor :x, :y, :width, :height
    attr_accessor :fill_type, :fill_color, :fill_other_color
    attr_accessor :line_type, :line_color, :line_width, :line_dash
    attr_accessor :shape, :shape_bezier    
    attr_accessor :text_string, :text_color, :text_size, :text_font, :text_markup
    
    attr_accessor :left_margi , :top_margin, :right_margin, :bottom_margin
    attr_accessor :left_inset, :top_inset, :right_inset, :bottom_inset
    attr_accessor :auto_layout_member, :unit_length, :layout_expand, :grid_frame
    attr_accessor :text_string, :text_color, :text_size, :text_font, :text_markup
    attr_accessor :image_path, :image_frame, :image_fit_type, :image_caption
    
    # TODO
    # attr_accessor :text_record, :image_record, :grid_record, :grid_frame, :auto_save
    
    
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      @parent_graphic.graphics << self if  @parent_graphic && @parent_graphic.graphics && !@parent_graphic.graphics.include?(self) 
      @klass          = options.fetch(:klass, defaults[:klass]) 
      @x              = options.fetch(:x, defaults[:x])
      @y              = options.fetch(:y, defaults[:y])
      @width          = options.fetch(:width, defaults[:width])
      @height         = options.fetch(:height, defaults[:height])
      @left_margin    = options.fetch(:left_margin, defaults[:left_margin])
      @top_margin    = options.fetch(:top_margin, defaults[:top_margin])
      @right_margin   = options.fetch(:right_margin, defaults[:right_margin])
      @bottom_margin  = options.fetch(:bottom_margin, defaults[:bottom_margin])
      @left_inset     = options.fetch(:left_inset, defaults[:left_inset])
      @top_inset      = options.fetch(:top_inset, defaults[:top_inset])
      @right_inset    = options.fetch(:right_inset, defaults[:right_inset])
      @bottom_inset   = options.fetch(:bottom_inset, defaults[:bottom_inset])
      @auto_layout_member    = options.fetch(:auto_layout_member, true)
      @layout_expand  = options.fetch(:layout_expand, defaults[:layout_expand])
      @unit_length    = options.fetch(:unit_length, defaults[:unit_length])
      @grid_frame     = options.fetch(:grid_frame, defaults[:grid_frame])             
      @tag            = options[:tag]      
      @fill_type      = options[:fill_type]
      @fill_color     = options[:fill_color]
      @fill_other_color= options[:fill_other_color]
      @line_type      = options[:line_type]
      @line_color     = options[:line_color]
      @line_width     = options[:line_width]
      @line_dash      = options[:line_dash]
      @shape          = options[:shape]
      @shape_bezier   = options[:shape_bezier]
      @text_string    = options[:text_string]
      @text_color     = options[:text_color]
      @text_size      = options[:text_size]
      @text_font      = options[:text_font]
      @text_markup    = options[:text_markup]
      @image_path     = options[:image_path]
      @image_frame    = options[:image_frame]
      @mage_fit_type  = options[:mage_fit_type]
      @image_caption  = options[:image_caption]      
      @auto_save      = options[:auto_save]

      self
    end
    
    #TODO
    def graphics_space_sum
      0
    end
    
    def self.with(parent_graphic, style_name, &block)
      Graphic.new(parent_graphic, Style.shared_style(style_name), &block)
    end
    
    def defaults
      {
        klass: "Rectangle",
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        left_margin: 0,
        top_margin: 0,
        right_margin: 0,
        bottom_margin: 0,
        auto_layout_member: true,
        left_inset: 0,
        top_inset: 0,
        right_inset: 0,
        bottom_inset: 0,
        layout_expand: [:width, :height], # auto_layout expand 
        unit_length: 1,  
        grid_frame: [0,0,1,1],            
      }
    end
    
    def puts_frame
      puts "@x:#{@x}"
      puts "@y:#{@y}"
      puts "@width:#{@width}"
      puts "@height:#{@height}"
    end
    
    def set_frame(frame)
      @x = frame[0]
      @y = frame[1]
      @width = frame[2]
      @height = frame[3]
    end
    
    def expand_width?
      @layout_expand.include?(:width)
    end
    
    def expand_height?
      @layout_expand.include?(:height)
    end
    
    def to_hash
      h = {}
      instance_variables.each{|a|
        s = a.to_s
        next if s=="@parent_graphic"
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil? && v !=defaults[n.to_sym]
      }
      h
    end
    
    #/0/0/1/2/0
    def ancestry
      s = ""
      if @parent_graphic
        s += @parent_graphic.ancestry 
        s += "," + @parent_graphic.graphics.index(self).to_s
      else
        s = ",0"
      end
      s
    end
    
    def to_mongo
      h = to_hash
      h[:_id] = ancestry
      puts h
      j = h.to_json
      j += "\n"
    end
    
    def to_svg
      if @parent_graphic
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
        svg_string += svg
        svg_string += "</svg>\n"
        return svg_string
      end
    end
    
    def svg
        s = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\""
        if @fill_color!=nil && @fill_color != ""
          s+= " fill=\"#{@fill_color}\""
        end
        if @line_width!=nil && @line_width > 0
          s+= " stroke=\"#{@line_color}\""
          s+= " stroke-width=\"#{@line_width}\""
        end
        s+= "></rect>\n"
        
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y}\" fill=\"#{@text_color}\">#{@text_string}</text>\n"
        end
        s
    end
    
    def text_record
      !@text_string.nil? 
    end
    
    def text_svg
      
    end
 
    def image_record
      !@image_path.nil? 
    end

    def image_svg
      
    end
    
    COLORS = %w[black blue gray green orange red purple yellow white]
    WIDTH = [1,3,5,8,10]
    def random_attributes
      h={}
      h[:fill_color] = COLORS.random
      h[:line_color] = COLORS.random
      h[:line_width] = WIDTH.random
      h
    end
  end
  
  class Rectangle < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Rectangle"
      
      self
    end
  end
  
  class Text < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Text"
      @text_string  = options.fetch(:string, "")
      @text_color   = options.fetch(:text_color, "black")
      @text_font   = options.fetch(:font, "Times")
      @text_size    = options.fetch(:text_size, 16)
      self
    end
    
  end
  
  class Circle < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Circle"
      
      self
    end
    
    def svg
      r = (@width <= @height) ? @width/2 : @height/2
      s = "<circle cx=\"#{@x+@width/2}\" cy=\"#{@y+@height/2}\" r=\"#{r}\""
      if @fill_color!=nil && @fill_color != ""
        s+= " fill=\"#{@fill_color}\""
      end
      if @line_width!=nil && @line_width > 0
        s+= " stroke=\"#{@line_color}\""
        s+= " stroke-width=\"#{@line_width}\""
      end
      s+= "></circle>\n"      
    end
  end
  
  class RoundRect < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "RoundRect"
      
      self
    end
    
    def svg
      shorter=(@width <= @height) ? @width : @height
      r=shorter*0.1
      s = "<rect x=\"#{@x}\" y=\"#{@y}\"  rx=\"#{r}\" ry=\"#{r}\" width=\"#{@width}\" height=\"#{@height}\""
      if @fill_color!=nil && @fill_color != ""
        s+= " fill=\"#{@fill_color}\""
      end
      if @line_width!=nil && @line_width > 0
        s+= " stroke=\"#{@line_color}\""
        s+= " stroke-width=\"#{@line_width}\""
      end
      s+= "></rect>\n"
    end
  end
end

