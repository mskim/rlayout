
module RLayout

  class Graphic
    attr_accessor :parent_graphic, :klass, :tag, :ns_view, :svg_view, :path
    attr_accessor :graphics, :fixtures, :floats
    attr_accessor :non_overlapping_rect
    attr_accessor :fill, :stroke, :shape, :text_record, :image_record

    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      if parent_graphic
        if options[:is_float]
          @parent_graphic.floats << self if !@parent_graphic.floats.include?(self)
          # init_float(options)
        elsif options[:is_fixture]
          #page fixtures, header, footer, side_bar are kept in fixtures array separate from other graphics
          @parent_graphic.fixtures << self if !@parent_graphic.fixtures.include?(self)
        elsif  @parent_graphic && @parent_graphic.kind_of?(RLayout::Document)
          @parent_graphic.pages << self  if !@parent_graphic.pages.include?(self)
        elsif !@parent_graphic.graphics.include?(self)
          @parent_graphic.graphics << self
        end
      end
      @klass = options.fetch(:klass, graphic_defaults[:klass])
      @x                = options.fetch(:x, graphic_defaults[:x])
      @y                = options.fetch(:y, graphic_defaults[:y])
      @width            = options.fetch(:width, graphic_defaults[:width])
      @height           = options.fetch(:height, graphic_defaults[:height])
      @shape            = options.fetch(:shape, RectStruct.new(@x,@y,@width,@height))
      @tag              = options[:tag]
      @auto_save        = options[:auto_save]
      init_layout(options)
      # if options[:grid_frame] is given, convert grid_frame to x,y,width,heigth of parent's grids cordinate
      if options[:grid_frame] && @parent_graphic #&& @parent_graphic.respond_to?(:grid_base)
        set_frame_in_parent_grid(options[:grid_frame]) if @parent_graphic.grid_base
        # disable autolayout
        @layout_expand = nil
      end
      init_fill(options)
      init_stroke(options)
      init_shape(options)
      init_text(options)
      init_image(options)
      
      self
    end

    def set_frame_in_parent_grid(grid_frame)
      set_frame(@parent_graphic.frame_for(grid_frame))
    end

    def graphic_defaults
      {
        klass: 'Rectangle',
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        shape: 0,
      }
    end
    
    def update_shape
      @shape = RectStruct.new(@x,@y,@width,@height)
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
    
    def self.upgrade_format(old_hash)
      key   = old_hash.keys.first
      new_hash = old_hash.values.first.dup
      new_hash[:klass]=key
      if new_hash[:graphics]
        new_graphics = []
        new_hash[:graphics].each do |child|
          new_graphics << self.upgrade_format(child)
        end
        new_hash[:graphics] = new_graphics
      end
      new_hash
    end
    
    def to_hash
      h = {}
      h[:klass]   = @klass
      h[:x]       = @x        if @x != graphic_defaults[:x]
      h[:y]       = @y        if @y != graphic_defaults[:y]
      h[:width]   = @width    if @width != graphic_defaults[:width]
      h[:height]  = @height   if @height != graphic_defaults[:height]
      h[:tag]     = @tag      if @tag
      h.merge!(layout_to_hash) 
      h.merge!(@fill.to_hash)   if @fill
      h.merge!(@stroke.to_hash) if @stroke
      h.merge!(@shape.to_hash)  if @shape
      h.merge!(@text.to_hash)   if @text_record
      h.merge!(@image.to_hash)  if @image_record
      h
    end

    def tag=(new_tag)
      @tag = new_tag
      self
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
    def self.random_text
      TEXT_STRING_SAMPLES.sample
    end
    
    def random_text
      TEXT_STRING_SAMPLES.sample
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

    def min_x(rect)
      rect[0]
    end
    
    def min_y(rect)
      rect[1]
    end
    
    def mid_x(rect)
      rect[0] + rect[2]/2
    end
    
    def mid_y(rect)
      rect[1] + rect[3]/2
    end
    
    def max_x(rect)
      rect[0] + rect[2]
    end
    
    def max_y(rect)
      rect[1] + rect[3]
    end
    
    def contains_rect(rect_1,rect_2)
      (rect_1[0]<=rect_2[0] && max_x(rect_1) >= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && max_y(rect_1) >= max_y(rect_2))
    end
    
    def intersects_x(rect1, rect2)
      (max_x(rect1) > rect2[0] && max_x(rect2) > rect1[0]) || (max_x(rect2) > rect1[0] && max_x(rect1) > rect2[0])
    end
    
    def intersects_y(rect1, rect2)
      (max_y(rect1) > rect2[1] && max_y(rect2) > rect1[1]) || (max_y(rect2) > rect1[1] && max_y(rect1) > rect2[1])
    end
    
    def intersects_rect(rect_1, rect_2)
      intersects_x(rect_1, rect_2) && intersects_y(rect_1, rect_2)
    end

    def self.random_graphic_atts
      atts = {}
      atts[:fill_color] = random_color
      atts[:x]          = Random.new.rand(0..600)
      atts[:y]          = Random.new.rand(0..800)
      atts[:width]      = Random.new.rand(10..200)
      atts[:height]     = Random.new.rand(10..200)
      atts[:line_width] = Random.new.rand(0..10)
      atts[:line_color] = random_color
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
      when "Ellipse"
        Ellipse.new(parent_graphic, options)
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

    def bounds_rect
      [0,0,@width,@height]
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
      #
      if @non_overlapping_rect
        return @non_overlapping_rect
      end
      bounds_rect
    end

    def non_overlapping_bounds
      if @non_overlapping_rect
        non_overlapping_rect = @non_overlapping_rect.dup
        [non_overlapping_rect[0] - @x,non_overlapping_rect[1] - @y,@width,@height]
      end
      [0,0,@width,@height]
    end

    def puts_frame
      puts "@x:#{@x}"
      puts "@y:#{@y}"
      puts "@width:#{@width}"
      puts "@height:#{@height}"
    end

    def puts_margin
      puts "@left_margin:#{@left_margin}"
      puts "@top_margin:#{@top_margin}"
      puts "@right_margin:#{@right_margin}"
      puts "@bottom_margin:#{@bottom_margin}"
      puts "@left_inset:#{@left_inset}"
      puts "@top_inset:#{@top_inset}"
      puts "@right_inset:#{@right_inset}"
      puts "@bottom_inset:#{@bottom_inset}"

    end

    def set_frame(frame)
      @x = frame[0]
      @y = frame[1]
      @width = frame[2]
      @height = frame[3]
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
        @height = @text_layout_manager.text_container[3] + @top_margin + @top_inset + @bottom_margin + @bottom_inset
      else
        old_width = @width
        old_height = @height
        @width  = new_width
        @height = new_width/old_width*old_height
      end
    end

    def expand_width?
      return false unless @layout_expand && @layout_expand.class == Array
      @layout_expand.include?(:width)
    end

    def expand_height?
      return false unless @layout_expand && @layout_expand.class == Array
      @layout_expand.include?(:height)
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

    def save_pdf(path, options={})
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path, options)
      end
      #TODO
      # puts "DRb not found!!!!"
    end

    def save_jpg(path)
      @ns_view ||= GraphicViewMac.from_graphic(self)
      @ns_view.save_jpg(path)
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
          radius = smaller_side*0.1
        elsif @corner_size == 1 # "medium" || @corner_size == '중'
          radius = smaller_side*0.2
        elsif @corner_size == 2 #{}"large" || @corner_size == '대'
          radius = smaller_side*0.3
        else
          radius = smaller_side*0.1
        end

        if @inverted_corner
          path = path.appendBezierPathWithRoundedRect(r, xRadius:radius ,yRadius:radius)
        else
          # do inverted corner
          path = path.appendBezierPathWithRoundedRect(r, xRadius:radius ,yRadius:radius)
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

    # # convert any color to NSColor
    # def self.convert_to_nscolor(color)
    #   return self.color_from_string(color) if color.class == String
    #   color
    # 
    # end


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
          @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[2].to_f, alpha:color_values[3].to_f)
      elsif color_kind=~/CMYK/
          @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[2].to_f, black:color_values[3].to_f, alpha:color_values[4].to_f)
      elsif color_kind=~/NSCalibratedWhiteColorSpace/
          @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
      elsif color_kind=~/NSCalibratedBlackColorSpace/
          @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)
      else
          @color = GraphicRecord.color_from_name(color_string)
      end
      @color
    end

    def fit_text_to_box
      @text_layout_manager.fit_text_to_box  if @text_layout_manager
    end
  end

  class Text < Graphic
    def initialize(parent_graphic, options={})
      # options[:line_width] = 2
      # options[:line_color] = 'red'
      # options[:text_fit_type] = 1 unless options[:text_fit_type]
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
      self
    end
  end

  class Image < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass        = "Image"
      if options[:image_path]
        @image_path   = options[:image_path]
        @image_record = ImageStruct.new(options[:image_path])
      elsif options[:image_record]
        @image_record = ImageStruct.new(*options[:image_record])
      end
      self
    end

  end

  class Circle < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Circle"
      update_shape
      self
    end
    
    def update_shape
      shorter = @width < @height ? @width : @height
      @shape = CircleStruct.new(@x + @width/2, @y + @height/2, shorter/2)
    end
  end
  
  class Ellipse < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Ellipse"
      update_shape
      self
    end
    def update_shape
      @shape = EllipseStruct.new((@x+@width)/2, (@y + @height)/2, @width/2, @height/2)
    end

  end

  class RoundRect < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "RoundRect"
      update_shape
      self
    end
    def update_shape
      shorter = @width < @height ? @width : @height
      r= shorter/10
      @shape = RoundRectStruct.new(@x, @y, @width, @height, r, r)
    end

  end
  
  class Line < Graphic
    def initialize(parent_graphic, options={})
      super
      @klass = "Line"
      update_shape
      self
    end
    def update_shape
      @shape = LineStruct.new(@x, @y, @x + @width, @y + @height)
    end
    
  end
end
