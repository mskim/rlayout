
module RLayout
  
  class Graphic
    attr_accessor :parent_graphic, :klass, :tag
    attr_accessor :x, :y, :width, :height
    attr_accessor :fill_type, :fill_color, :fill_other_color
    attr_accessor :line_type, :line_color, :line_width, :line_dash
    attr_accessor :shape, :shape_bezier    
    attr_accessor :text_string, :text_color, :text_size, :text_font
    attr_accessor :left, :top, :right, :bottom
    attr_accessor :left_inset, :top_inset, :right_inset, :bottom_inset
    attr_accessor :auto_layout_member, :unit_length, :layout_expand
    attr_accessor :grid_x, :grid_y, :grid_width, :grid_height
    
    # TODO
    attr_accessor :text_record, :image_record, :grid_record, :grid_frame
    
    
    def initialize(parent_graphic, options={}, &block)
      @defaults = defaults
      @parent_graphic = options.fetch(:parent_graphic, @defaults[:parent_graphic])       
      @klass          = options.fetch(:klass, @defaults[:klass]) 
      @tag            = options.fetch(:tag, @defaults[:tag])      
      @x              = options.fetch(:x, @defaults[:x])
      @y              = options.fetch(:y, @defaults[:y])
      @width          = options.fetch(:width, @defaults[:width])
      @height         = options.fetch(:height, @defaults[:height])
      
      @fill_type      = options.fetch(:fill_type, @defaults[:fill_type])
      @fill_color     = options.fetch(:fill_color, @defaults[:fill_color])
      @fill_other_color= options.fetch(:fill_other_color, @defaults[:fill_other_color])
      
      @line_type      = options.fetch(:line_type, @defaults[:line_type])
      @line_color     = options.fetch(:line_color, @defaults[:line_color])
      @line_width     = options.fetch(:line_width, @defaults[:line_width])
      @line_dash      = options.fetch(:line_dash, @defaults[:line_dash])
      
      @shape          = options.fetch(:shape, @defaults[:shape])
      @shape_bezier   = options.fetch(:shape_bezier, @defaults[:shape_bezier])
      
      @left           = options.fetch(:left, @defaults[:left])
      @top            = options.fetch(:top, @defaults[:top])
      @right          = options.fetch(:right, @defaults[:right])
      @bottom         = options.fetch(:bottom, @defaults[:bottom])
      @left_inset     = options.fetch(:left_inset, @defaults[:left_inset])
      @top_inset      = options.fetch(:top_inset, @defaults[:top_inset])
      @right_inset    = options.fetch(:right_inset, @defaults[:right_inset])
      @bottom_inset   = options.fetch(:bottom_inset, @defaults[:bottom_inset])

      @auto_layout_member    = options.fetch(:auto_layout_member, true)
      @layout_expand  = options.fetch(:layout_expand, @defaults[:layout_expand])
      @unit_length    = options.fetch(:unit_length, @defaults[:unit_length])
      @grid_x         = options.fetch(:grid_x, @defaults[:grid_x])
      @grid_y         = options.fetch(:grid_y, @defaults[:grid_y])
      @grid_width     = options.fetch(:grid_width, @defaults[:grid_width])
      @grid_height    = options.fetch(:grid_height, @defaults[:grid_height])
      
      @text_record    = options.fetch(:text_record, nil)
      @image_record   = options.fetch(:image_record, nil)

      self
    end
    
    def self.with(parent_graphic, style_name, &block)
      Graphic.new(parent_graphic, Style.shared_style(style_name), &block)
    end
    
    def defaults
      {
        parent_graphic: nil,
        klass: "Rectangle",
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        fill_type: "plain",
        fill_color: "white",
        fill_other_color: "gray",
        line_type: "single",
        line_color: "black",
        line_width: 0,
        line_dash: nil,
        shape: "rect",
        shape_bezier: nil,
        left: 0,
        top: 0,
        right: 0,
        bottom: 0,
        left_inset: 0,
        top_inset: 0,
        right_inset: 0,
        bottom_inset: 0,
        auto_layout_member: true,
        layout_expand: [:width, :height], # auto_layout expand 
        unit_length: 1,
        grid_x: 0,
        grid_y: 0,
        grid_width: 1,
        grid_height: 1,
        
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
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil? && v !=defaults[n.to_sym]
      }
      h
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

