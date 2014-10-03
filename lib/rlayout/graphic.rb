require 'json'
# PageScript Verbs
#  rect
#  circle
#  round_rect

#  line_type=
require File.dirname(__FILE__) + "/graphic/layout"
require File.dirname(__FILE__) + "/graphic/fill"
require File.dirname(__FILE__) + "/graphic/line"
require File.dirname(__FILE__) + "/graphic/image"
require File.dirname(__FILE__) + "/graphic/text"
require File.dirname(__FILE__) + "/graphic/float"

module RLayout
  
  class Graphic
    attr_accessor :parent_graphic, :klass, :tag, :ns_view, :svg_view
    attr_accessor :x, :y, :width, :height
    attr_accessor :graphics
    attr_accessor :fill_type, :fill_color, :fill_other_color
    attr_accessor :line_type, :line_color, :line_width, :line_dash
    attr_accessor :shape, :shape_bezier        
    attr_accessor :left_margin , :top_margin, :right_margin, :bottom_margin
    attr_accessor :left_inset, :top_inset, :right_inset, :bottom_inset
    attr_accessor :layout_direction, :layout_member, :layout_length, :layout_expand, :grid_rect
    attr_accessor :text_string, :text_color, :text_size, :text_line_spacing, :text_font, :text_fit_type, :text_alignment
    attr_accessor :image_path, :image_frame, :image_fit_type, :image_caption
    attr_accessor :non_overlapping_rect, :overlapping_rects
    
    # TODO
    # attr_accessor :text_record, :image_record, :grid_record, :grid_rect, :auto_save
    
    
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      if options[:is_float]
        @parent_graphic.floats << self if @parent_graphic.floats && !@parent_graphic.floats.include?(self)
        init_float(options)
      elsif options[:is_fixture]
        #page fixtures, header, footer, side_bar are kept in fixtures array separate from other graphics
        @parent_graphic.fixtures << self if @parent_graphic.fixtures && !@parent_graphic.fixtures.include?(self)        
      elsif  @parent_graphic && @parent_graphic.graphics && !@parent_graphic.graphics.include?(self)
        @parent_graphic.graphics << self  
      end
      
      defaults_hash     = defaults
      @klass            = options.fetch(:klass, defaults_hash[:klass]) 
      @x                = options.fetch(:x, defaults_hash[:x])
      @y                = options.fetch(:y, defaults_hash[:y])
      @width            = options.fetch(:width, defaults_hash[:width])
      @height           = options.fetch(:height, defaults_hash[:height])
      @grid_rect        = options.fetch(:grid_rect, defaults_hash[:grid_rect]) 
      @shape            = options.fetch(:shape, defaults_hash[:shape])
      @tag              = options[:tag]      
      @shape_bezier     = options[:shape_bezier]
      @auto_save        = options[:auto_save]
      
      init_layout(options)
      init_fill(options)
      init_line(options)
      init_text(options)
      init_image(options)
      # init_float(options) # for ObjectBox where float makes sense      
      self
    end

    def defaults
      {
        klass:        'Rectangle',
        x:            0,
        y:            0,
        width:        100,
        height:       100,
        left_margin:  0,
        top_margin:   0,
        right_margin: 0,
        bottom_margin: 0,
        left_inset:   0,
        top_inset:    0,
        right_inset:  0,
        bottom_inset: 0,
        layout_direction: "vertical",
        layout_member: true,
        layout_expand: [:width, :height], # auto_layout expand 
        layout_length:  1,  
        grid_rect:   [0,0,1,1], 
        shape:       0,          
      }
    end
       
COLOR_NAMES =%w[black blue brown clear cyan darkGray gray green lightGray magenta orange red white yellow white]
KLASS_NAMES =%w[Rectangle Circle RoundRect Text Image]
TEXT_STRING_SAMPLES =["This is a text", "Good Morning", "Nice", "Cool", "RLayout", "PageScript"]
    
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
    
    
    def self.with(parent_graphic, style_name, &block)
      Graphic.new(parent_graphic, Style.shared_style(style_name), &block)
    end
    
    def frame_rect
      [@x,@y,@width,@height]
    end 
    
    # non_overlapping_rect is a actual layout frame that is not overlapping with flaots
    def non_overlapping_frame
      return @non_overlapping_rect if @non_overlapping_rect
      frame_rect
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
    
    def change_width_and_adjust_height(new_width, options={})
      old_width = @width
      old_height = @height
      @width  = new_width
      @height = new_width/old_width*old_height
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
    # to_data is uesed to send the data to view for drawing 
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
    
    def save_pdf(path)
      if RUBY_ENGINE == 'macruby'
        @ns_view = GraphicViewMac.from_data(to_data)
        @ns_view.save_pdf(path)
        #TODO
        # puts "DRb not found!!!!"
      end
    end
  end
  
  class Text < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Text"
      self
    end
    
    # def change_width_and_adjust_height(new_width, options={})
    #   old_width = @width
    #   old_height = @height
    #   @width  = new_width
    #   layout_lines
    #         
    #   # change height we need to
    # end
    
    def self.sample(options={})
      if options[:number] > 0
        Text.new(nil, text_string: "This is a sample text string"*options[:number])
      else
        Text.new(nil, text_string: "This is a sample text string")
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
    
  end
  
  class RoundRect < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "RoundRect"
      @shape = 1
      
      self
    end
    
  end
end

