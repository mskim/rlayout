require 'json'
# PageScript Verbs
#  rect
#  circle
#  round_rect

#  line_type=
require File.dirname(__FILE__) + "/graphic/layout"
require File.dirname(__FILE__) + "/graphic/grid"
require File.dirname(__FILE__) + "/graphic/fill"
require File.dirname(__FILE__) + "/graphic/line"
require File.dirname(__FILE__) + "/graphic/image"
require File.dirname(__FILE__) + "/graphic/text"
require File.dirname(__FILE__) + "/graphic/float"

X_POS       = 0
Y_POS       = 1
WIDTH_VAL   = 2
HEIGHT_VAL  = 3

module RLayout
  
  class Graphic
    attr_accessor :parent_graphic, :klass, :tag, :ns_view, :svg_view
    attr_accessor :x, :y, :width, :height
    attr_accessor :graphics, :fixtures, :floats
    attr_accessor :fill_type, :fill_color, :fill_other_color
    attr_accessor :line_type, :line_color, :line_width, :line_dash
    attr_accessor :shape, :shape_bezier        
    attr_accessor :left_margin , :top_margin, :right_margin, :bottom_margin
    attr_accessor :left_inset, :top_inset, :right_inset, :bottom_inset
    attr_accessor :layout_direction, :layout_member, :layout_length, :layout_expand, :grid_rect
    attr_accessor :text_markup, :text_direction, :text_string, :text_color, :text_size, :text_line_spacing, :text_font
    attr_accessor :text_fit_type, :text_alignment, :text_tracking, :text_first_line_head_indent, :text_head_indent, :text_tail_indent, :text_paragraph_spacing_before, :text_paragraph_spacing
    attr_accessor :text_layout_manager
    attr_accessor :image_object, :image_path, :image_frame, :image_fit_type, :image_caption
    attr_accessor :non_overlapping_rect
    
    # TODO
    # attr_accessor :fill_record, :line_record, :shape_record, :text_record, :image_record, :grid_record, :layout_record    
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      if options[:is_float]
        @parent_graphic.floats << self if @parent_graphic.floats && !@parent_graphic.floats.include?(self)
        init_float(options)
      elsif options[:is_fixture]
        #page fixtures, header, footer, side_bar are kept in fixtures array separate from other graphics
        @parent_graphic.fixtures << self if @parent_graphic.fixtures && !@parent_graphic.fixtures.include?(self)        
      elsif  @parent_graphic && @parent_graphic.kind_of?(Document) && !@parent_graphic.pages.include?(self)
        @parent_graphic.pages << self  
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
      init_grid(options)
      init_fill(options)
      init_line(options)
      init_text(options)
      init_image(options)
      self
    end

    def defaults
      {
        klass: 'Rectangle',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        grid_rect: [0,0,1,1], 
        shape: 0,          
      }
    end
    
    def current_style
      if @parent_graphic && @parent_graphic.current_style
        return @parent_graphic.current_style
      end
      DEFAULT_STYLES
    end
    
    def heading_columns_for(column_number)
      @current_style["heading_columns"][column_number-1]
    end
    
    def body_height
      h = current_style['p']
      h[:text_size] + h[:text_line_spacing]      
    end
            
    def style_for_markup(markup, options={})
      h = @current_style[markup]
      h[:text_markup] = markup
      h
    end
    
    def to_hash
      defaults_hash = defaults
      h = {}
      h[:klass]   = @klass
      h[:x]       = @x        if @x != defaults_hash[:x]
      h[:y]       = @y        if @x != defaults_hash[:y]
      h[:width]   = @width    if @x != defaults_hash[:width]
      h[:height]  = @height   if @x != defaults_hash[:height]
      h[:tag]     = @tag      if @tag 
      
      h.merge!(layout_to_hash)
      h.merge!(grid_to_hash)
      h.merge!(fill_to_hash)
      h.merge!(line_to_hash)
      h.merge!(text_to_hash)
      h.merge!(image_to_hash)
      # h[:grid_rect]  = @grid_rect   if @grid_rect != defaults_hash[:grid_rect]
      # h[:shape]  = @shape   if @shape != defaults_hash[:shape]
      h
    end
    
    # difference between to_hash and to_data:
    # to_hash does not save values, if they are equal to default
    # to_data save values, even if they are equal to default
    # to_data is uesed to send the data to view for drawing 
    
    def to_data  
      h = {}
      instance_variables.each do |a|
        next if a == @parent_graphic
        next if a == @floats
        next if a == @graphics  
        v = instance_variable_get a
        s = a.to_s.sub("@","")
        h[s.to_sym] = v  if !v.nil?
      end
      h
    end
COLOR_NAMES =%w[black blue brown clear cyan darkGray gray green lightGray magenta orange red white yellow white]
KLASS_NAMES =%w[Rectangle Circle RoundRect Text Image]
TEXT_STRING_SAMPLES =["This is a text", "Good Morning", "Nice", "Cool", "RLayout", "PageScript"]
IMAGE_TYPES = %w[pdf jpg tiff png PDF JPG TIFF]
    def self.ramdom_text
      TEXT_STRING_SAMPLES.sample
    end
    def ramdom_text
      TEXT_STRING_SAMPLES.sample
    end
    
    def self.random_color
      COLOR_NAMES.sample
    end
    
    def random_color
      COLOR_NAMES.sample
    end
    
    def random_klass
      KLASS_NAMES.sample
    end
    
    def random_text
      TEXT_STRING_SAMPLES.sample
    end
    
    # Graphic item may need to be split into two, for layout
    # subclasses such as paragraph should be able to split
    # but the default is no
    def can_split_at?(some_position)
      false
    end
    
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
    
    def text_rect
      [@x + @left_inset , @y + @top_inset, @width - @left_inset - @right_inset, @height - @top_inset - @bottom_inset]
    end
    
    # when text_rect is changed, update frame height considering insets
    def adjust_height_with_text_height_change(text_height)
      @height = text_height + @top_inset + @bottom_inset      
    end
    
    # when text_rect is changed, update frame size considering insets
    def adjust_size_with_text_height_change(text_width, text_height)
      @width = text_width + @left_inset + @right_inset      
      @height = text_height + @top_inset + @bottom_inset      
    end
    
    # non_overlapping_rect is a actual layout frame that is not overlapping with flaots
    def non_overlapping_frame
      if @non_overlapping_rect
        return @non_overlapping_rect 
      end
      frame_rect
    end
    
    def non_overlapping_bounds
      if @non_overlapping_rect
        non_overlapping_rect = @non_overlapping_rect.dup
        [non_overlapping_rect[X_POS] - @x,non_overlapping_rect[1] - @y,@width,@height]
      end
      [0,0,@width,@height]
    end
    
    def puts_frame
      puts "@x:#{@x}"
      puts "@y:#{@y}"
      puts "@width:#{@width}"
      puts "@height:#{@height}"
    end
        
    def set_frame(frame)
      @x = frame[X_POS]
      @y = frame[1]
      @width = frame[WIDTH_VAL]
      @height = frame[HEIGHT_VAL]
      if @text_layout_manager
        @text_layout_manager.set_frame
      end
      
      if @image_object
        apply_fit_type
      end
    end
    
    def change_width_and_adjust_height(new_width, options={})
      unless @text_layout_manager.nil?
        @text_layout_manager.change_width_and_adjust_height(new_width, options={})
        @height = @text_layout_manager.text_container[HEIGHT_VAL] + @top_margin + @top_inset + @bottom_margin + @bottom_inset
      else
        old_width = @width
        old_height = @height
        @width  = new_width
        @height = new_width/old_width*old_height
      end
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
    
    def drawRect(r)
      draw_fill(r)
      draw_line(r)
      draw_text(r)
      draw_image(r)
    end
    
    def save_pdf(path)
      if RUBY_ENGINE == 'macruby'        
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path)
        #TODO
        # puts "DRb not found!!!!"
      end
    end
    
    
    def bezierPathWithRect(r)
      #TODO

      case @shape
      when 0   #{}"rectangle", '사각형'
        path = NSBezierPath.bezierPathWithRect(r)
      when 1    #{}"round_corner", '둥근사각형'
        path=NSBezierPath.bezierPath
        if r.size.width > r.size.height
          smaller_side = r.size.height 
        else
          smaller_side = r.size.width 
        end

        if @corner_size == 0 # "small" || @corner_size == '소'
          radious = smaller_side*0.1 
        elsif @corner_size == 1 # "medium" || @corner_size == '중'
          radious = smaller_side*0.2
        elsif @corner_size == 2 #{}"large" || @corner_size == '대'
          radious = smaller_side*0.3
        else
          radious = smaller_side*0.1 
        end

        if @inverted_corner
          path = path.appendBezierPathWithRoundedRect(r, xRadius:radious ,yRadius:radious)
        else
          # do inverted corner
          path = path.appendBezierPathWithRoundedRect(r, xRadius:radious ,yRadius:radious)
        end
      when 2 #{}"circle", '원'
        path = NSBezierPath.bezierPathWithOvalInRect(r)
      when 3 #{}"bloon"
        # pointer_direction 0, 45 , 90, 135, 180 ....
        path = NSBezierPath.bezierPathWithOvalInRect(r)
      when 4 #{}"spike"
        # density large, medium, small
        path = NSBezierPath.bezierPathWithOvalInRect(r)
      else
        path = NSBezierPath.bezierPathWithRect(r)
      end
      path
    end

    # convert any color to NSColor
    def self.convert_to_nscolor(color)
      return self.color_from_string(color) if color.class == String
      color
      
    end
    
    def convert_to_nscolor(color)
      return color_from_string(color) if color.class == String
      color
    end

    def self.color_from_name(name)
      case name
      when "black"
        return NSColor.blackColor
      when "blue"
        return NSColor.blueColor
      when "brown"
        return NSColor.brownColor
      when "clear"
        return NSColor.clearColor
      when "cyan"
        return NSColor.cyanColor
      when "dark_gray", "darkGray"
        return NSColor.darkGrayColor
      when "gray"
        return NSColor.grayColor
      when "green"
        return NSColor.greenColor
      when "light_gray", "lightGray"
        return NSColor.lightGrayColor
      when "magenta"
        return NSColor.magentaColor
      when "orange"
        return NSColor.orangeColor
      when "purple"
        return NSColor.purpleColor
      when "red"
        return NSColor.redColor
      when "white"
        return NSColor.whiteColor
      when "yellow"
        return NSColor.yellowColor      
      else
        return NSColor.whiteColor      
      end
    end  
    
    
    def color_from_name(name)
      case name
      when "black"
        return NSColor.blackColor
      when "blue"
        return NSColor.blueColor
      when "brown"
        return NSColor.brownColor
      when "clear"
        return NSColor.clearColor
      when "cyan"
        return NSColor.cyanColor
      when "dark_gray", "darkGray"
        return NSColor.darkGrayColor
      when "gray"
        return NSColor.grayColor
      when "green"
        return NSColor.greenColor
      when "light_gray", "lightGray"
        return NSColor.lightGrayColor
      when "magenta"
        return NSColor.magentaColor
      when "orange"
        return NSColor.orangeColor
      when "purple"
        return NSColor.purpleColor
      when "red"
        return NSColor.redColor
      when "white"
        return NSColor.whiteColor
      when "yellow"
        return NSColor.yellowColor      
      else
        return NSColor.whiteColor      
      end
    end  
    
    def self.color_from_string(color_string) 
      if color_string == nil
        return NSColor.whiteColor
      end

      if color_string==""
        return NSColor.whiteColor
      end

      if COLOR_NAMES.include?(color_string)
        return self.color_from_name(color_string)
      end
      # TODO
      # elsif color_string=~/^#   for hex color

      color_array=color_string.split("=")
      color_kind=color_array[0]
      color_values=color_array[1].split(",")
      if color_kind=~/RGB/
          @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[WIDTH_VAL].to_f, alpha:color_values[HEIGHT_VAL].to_f)
      elsif color_kind=~/CMYK/
          @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[WIDTH_VAL].to_f, black:color_values[HEIGHT_VAL].to_f, alpha:color_values[4].to_f)
      elsif color_kind=~/NSCalibratedWhiteColorSpace/
          @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
      elsif color_kind=~/NSCalibratedBlackColorSpace/
          @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)      
      else 
          @color = GraphicRecord.color_from_name(color_string)    
      end
      @color
    end 
    

    def color_from_string(color_string)    
      if color_string == nil
        return NSColor.whiteColor
      end

      if color_string==""
        return NSColor.whiteColor
      end

      if COLOR_NAMES.include?(color_string)
        return color_from_name(color_string)
      end
      # TODO
      # elsif color_string=~/^#   for hex color

      color_array=color_string.split("=")
      color_kind=color_array[0]
      color_values=color_array[1].split(",")
      if color_kind=~/RGB/
          @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[WIDTH_VAL].to_f, alpha:color_values[HEIGHT_VAL].to_f)
      elsif color_kind=~/CMYK/
          @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[WIDTH_VAL].to_f, black:color_values[HEIGHT_VAL].to_f, alpha:color_values[4].to_f)
      elsif color_kind=~/NSCalibratedWhiteColorSpace/
          @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
      elsif color_kind=~/NSCalibratedBlackColorSpace/
          @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)      
      else 
          @color = GraphicRecord.color_from_name(color_string)    
      end
      @color
    end

  end
  
  class Text < Graphic
    def initialize(parent_graphic, options={})
      # options[:line_width] = 2
      # options[:line_color] = 'red'
      super
      @klass = "Text"
      self
    end
    
    def text_string
      return nil unless @text_layout_manager
      @text_layout_manager.att_string.string
    end
    
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

