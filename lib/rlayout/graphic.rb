require 'json'
# PageScript Verbs
#  rect
#  circle
#  round_rect

#  line_type=

module RLayout
  
  class Graphic
    attr_accessor :parent_graphic, :klass, :tag, :ns_view
    attr_accessor :x, :y, :width, :height
    attr_accessor :graphics
    attr_accessor :fill_type, :fill_color, :fill_other_color
    attr_accessor :line_type, :line_color, :line_width, :line_dash
    attr_accessor :shape, :shape_bezier        
    attr_accessor :left_margin , :top_margin, :right_margin, :bottom_margin
    attr_accessor :left_inset, :top_inset, :right_inset, :bottom_inset
    attr_accessor :layout_direction, :layout_member, :layout_length, :layout_expand, :grid_rect
    attr_accessor :text_string, :text_color, :text_size, :text_font, :text_fit_type
    attr_accessor :image_path, :image_frame, :image_fit_type, :image_caption
    
    # TODO
    # attr_accessor :text_record, :image_record, :grid_record, :grid_rect, :auto_save
    
    
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      if  @parent_graphic && @parent_graphic.graphics && !@parent_graphic.graphics.include?(self)
        @parent_graphic.graphics << self  
      end
      @klass          = options.fetch(:klass, "Rectangle") 
      @x              = options.fetch(:x, defaults[:x])
      @y              = options.fetch(:y, defaults[:y])
      @width          = options.fetch(:width, defaults[:width])
      @height         = options.fetch(:height, defaults[:height])
      @left_margin    = options.fetch(:left_margin, defaults[:left_margin])
      @top_margin     = options.fetch(:top_margin, defaults[:top_margin])
      @right_margin   = options.fetch(:right_margin, defaults[:right_margin])
      @bottom_margin  = options.fetch(:bottom_margin, defaults[:bottom_margin])
      @left_inset     = options.fetch(:left_inset, defaults[:left_inset])
      @top_inset      = options.fetch(:top_inset, defaults[:top_inset])
      @right_inset    = options.fetch(:right_inset, defaults[:right_inset])
      @bottom_inset   = options.fetch(:bottom_inset, defaults[:bottom_inset])
      @layout_direction= options.fetch(:layout_direction, defaults[:layout_direction])
      @layout_member  = options.fetch(:layout_member, defaults[:layout_member])
      @layout_expand  = options.fetch(:layout_expand, defaults[:layout_expand])
      @layout_length  = options.fetch(:layout_length, defaults[:layout_length])
      @grid_rect      = options.fetch(:grid_rect, defaults[:grid_rect]) 
      @shape          = options.fetch(:shape, defaults[:shape])
                  
      @tag            = options[:tag]      
      @fill_type      = options[:fill_type]
      @fill_color     = options[:fill_color]
      @fill_other_color= options[:fill_other_color]
      @line_type      = options[:line_type]
      @line_color     = options[:line_color]
      @line_width     = options[:line_width]
      @line_dash      = options[:line_dash]
      @shape_bezier   = options[:shape_bezier]
      @text_string    = options[:text_string]
      @text_color     = options[:text_color]
      @text_size      = options[:text_size]
      @text_font      = options[:text_font]
      @text_fit_type  = options[:text_fit_type]
      @image_path     = options[:image_path]
      @image_frame    = options[:image_frame]
      @mage_fit_type  = options[:mage_fit_type]
      @image_caption  = options[:image_caption]      
      @auto_save      = options[:auto_save]
      
      self
    end

    def defaults
      {
        x:            0,
        y:            0,
        width:        100,
        height:       100,
        left_margin:  0,
        top_margin:   0,
        right_margin: 0,
        bottom_margin: 0,
        layout_member: true,
        left_inset:   0,
        top_inset:    0,
        right_inset:  0,
        bottom_inset: 0,
        layout_direction: "vertical",
        layout_expand: [:width, :height], # auto_layout expand 
        layout_length:  1,  
        grid_rect:   [0,0,1,1], 
        shape:       0,          
      }
    end
       
    COLOR_NAMES = %w[black blue brown clear cyan darkGray gray green lightGray magenta orange red white yellow white]
    KLASS_NAMES = %w[Rectangle Circle RoundRect Text Image]
    TEXT_STRING_SAMPLES = ["This is a text", "Good Morning", "Nice", "Cool", "RLayout", "PageScript"]
    
    def self.random_graphic_atts
      atts = {}
      atts[:fill_color] = COLOR_NAMES.sample
      atts[:x]          = Random.new.rand(0..600)
      atts[:y]          = Random.new.rand(0..800)
      atts[:width]      = Random.new.rand(10..200)
      atts[:height]     = Random.new.rand(10..200)
      atts[:line_width] = Random.new.rand(0..10)
      atts[:line_color] = COLOR_NAMES.sample
      atts
    end
    
    def self.random_graphics(number=1)
      #TODO
      samples = []
      number.times do
        klass_name = KLASS_NAMES.sample
        data = Graphic.random_graphic_atts
        if klass_name == "Text"
          data[:text_string] = TEXT_STRING_SAMPLES.sample
        elsif klass_name == "Image"
          # puts path = File.dirname(__FILE__) + "/../../spec/image/1.jpg"
          # puts File.exists?(path)
          data[:image_path] = File.dirname(__FILE__) + "/../../spec/image/1.jpg"
        end
        samples << Graphic.klass_of(nil,klass_name, data)
      end
      samples
    end
    
    def self.klass_of(parent_graphic, klass, options={})
      case klass
      when "Rectanle"
        Rectangle.new(parent_graphic, options)
      when "Circle"
        Circle.new(parent_graphic, options)
      when "RoundRect"
        RoundRect.new(parent_graphic, options)
      when "Text"
        Text.new(parent_graphic, options)
      else
        Rectangle.new(parent_graphic, options)
      end
    end
    
    #TODO
    def graphics_space_sum
      0
    end
    
    def self.with(parent_graphic, style_name, &block)
      Graphic.new(parent_graphic, Style.shared_style(style_name), &block)
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
    
    def pretty_json
      require 'json'
      # my_json = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
      JSON.pretty_generate(to_hash)
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
    
    # difference between to_hash and to_data:
    # to_hash does not save values, if they are equal to default
    # to_data save values, even if they are equal to default
    # to_data is uesed to send the data for drawing in the view
    def to_data
      h = {}
      instance_variables.each{|a|
        s = a.to_s
        next if s=="@parent_graphic"
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil?
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
    
    def save_pdf(path)
      if RUBY_ENGINE == 'macruby'
        @ns_view = GraphicViewMac.from_data(to_data)
        @ns_view.save_pdf(path)
      else
        #TODO
        puts "Not a Mac! or no DRb not found!!!!"
      end
      
    end
  end
  
  class Rectangle < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Rectangle"
      @shape = 0
      self
    end
  end
  
  class Text < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Text"
      @text_string    = options.fetch(:text_string, "")
      @text_color     = options.fetch(:text_color, "black")
      @text_font      = options.fetch(:text_font, "Times")
      @text_size      = options.fetch(:text_size, 16)
      @text_fit_type  = options.fetch(:text_fit_type, 0)
      @text_alignment = options.fetch(:text_alignment, "center")
      self
    end
  end

  class Image < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass        = "Image"
      @image_path   = options.fetch(:image_path, "")
      self
    end
  end
  
  class Circle < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Circle"
      @shape = 2
      
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
      @shape = 1
      
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

