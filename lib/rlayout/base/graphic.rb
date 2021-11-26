
module RLayout
  
  # using from_right, and from_bottom option
  # {from_right: 20, from_bottom: 20}
  # It's a pain in the neck to place graphic to the right/bottom of the parent.
  # caller has to calculate x, and y value of graphic before hand, using parent object's width and height.
  # It gets even worse, if parent size is auto adjusted.
  # from_right, and from_bottom options are solutions for this.
  # if a graphic has parent, and from_right/from_bottom option is given, 
  # x/y values is auto calculated from its parent, caller just need width and height of the graphic.

  class Graphic
    attr_accessor :parent, :x, :y, :width, :height, :tag, :ns_view, :pdf_view, :svg_view, :path
    attr_accessor :graphics, :fixtures, :floats, :grid_frame
    attr_accessor :non_overlapping_rect, :z_order
    attr_accessor :fill, :stroke, :shape, :text_record, :image_record
    attr_accessor :frame_image, :shadow, :rotation, :right_anchor, :center_anchor_at, :bottom_anchor
    attr_reader   :pdf_doc, :project_path , :from_right, :from_bottom


    def initialize(options={}, &block)
      @parent = options[:parent] if options[:parent]
      @tag            = options[:tag]
      @project_path   = options[:project_path]
      @x              = options.fetch(:x, graphic_defaults[:x])
      @y              = options.fetch(:y, graphic_defaults[:y])
      @width          = options.fetch(:width, graphic_defaults[:width])
      @height         = options.fetch(:height, graphic_defaults[:height])
      if options[:page_size]
        size   = SIZES[options[:page_size]]
        @width = size[0]
        @height = size[1]
      end
      if @parent 
        if options[:parent_frame]
          set_frame(@parent.layout_rect)
        elsif options[:grid_frame] && @parent.grid
          # if options[:grid_frame] is given, convert grid_frame to x,y,width,height of parent's grid cordinate
          set_frame_in_parent_grid(options[:grid_frame])
          # disable autolayout
          @layout_expand = nil
        elsif options[:from_right]
          @from_right     = options[:from_right]
          @width          = options.fetch(:width, graphic_defaults[:width])
          @x              = @parent.width - @from_right - @width
        elsif options[:from_bottom] 
          @from_bottom    = options[:from_bottom]
          @height         = options.fetch(:height, graphic_defaults[:height])
          @y              = @parent.height - @from_bottom - @height
        end
      end
      @shape            = options.fetch(:shape, RectStruct.new(@x,@y,@width,@height))
      @auto_save        = options[:auto_save]
      init_layout(options)
      init_fill(options)
      init_stroke(options)
      init_shape(options)
      init_shadow(options)    if options[:shadow]
      init_rotation(options)  if options[:rotation] || options[:rotation_content] || options[:rotate_content]
      init_text(options)      if (options[:text_string] || options[:string]) && self.kind_of?(Text) 
      # init_image(options)
      if @parent.nil?
        return self
      end
      if @parent.kind_of?(Document) || @parent.kind_of?(RDocument) || @parent.kind_of?(PictureSpread)
        @parent.pages << self if  !parent.pages.include?(self)
      elsif options[:is_float]
        @parent.floats << self if @parent.floats && !@parent.floats.include?(self)
        # init_float(options)
      elsif options[:is_fixture]
        #page fixtures, header, footer, side_bar are kept in fixtures array separate from other graphics
        @parent.fixtures << self if !@parent.fixtures.include?(self)
      elsif @parent.respond_to?(:graphics) && @parent.graphics && !@parent.graphics.include?(self)
        @parent.graphics << self
      end
      self
    end

    def set_frame_in_parent_grid(grid_frame)
      set_frame(@parent.frame_for(grid_frame))
    end

    def graphic_defaults
      {
        x: 0,
        y: 0,
        width: 100,
        height: 100,
        shape: 0,
      }
    end

    def graphics_index
      @parent.graphics.index(self) if @parent && @parent.graphics
    end

    def next_graphic
      i = graphics_index
      return @parent.graphics[i + 1] if @parent.graphics.length >= i+1
      nil
    end

    def first_graphic?
      @parent.graphics.first == self
    end

    def last_graphic?
      @parent.graphics.last == self
    end

    def floats_index
      @parent.floats.index(self) if @parent && @parent.floats
    end

    def get_stroke_rect
      if RUBY_ENGINE == "rubymotion"
        # r = NSMakeRect(@x,@y,@width,@height)
        r = NSMakeRect(@left_margin,@top_margin,@width - (@left_margin + @right_margin) ,@height- (@top_margin + @bottom_margin))

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
        #TODO
        [@left_margin, @top_margin, @width - (@left_margin + @right_margin) ,@height- (@top_margin + @bottom_margin)]
      end
    end

    def update_shape
      @shape = RectStruct.new(@x,@y,@width,@height)
    end

    def current_style
      RLayout::StyleService.shared_style_service.current_style
    end

    def heading_columns_for(column_number)
      current_style["heading_columns"][column_number-1]
    end

    def body_height
      h = current_style['p']
      h[:font_size] + h[:text_line_spacing]
    end

    def is_breakable?
      false
    end

    def style_for_markup(markup, options={})
      h = current_style[markup]
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
      klass   = self.class
      atts = {}
      atts[:x]       = @x        if @x != graphic_defaults[:x]
      atts[:y]       = @y        if @y != graphic_defaults[:y]
      atts[:width]   = @width    if @width != graphic_defaults[:width]
      atts[:height]  = @height   if @height != graphic_defaults[:height]
      atts[:tag]     = @tag      if @tag
      atts.merge!(layout_to_hash)
      atts.merge!(@fill.to_hash)   if @fill
      atts.merge!(@stroke.to_hash) if @stroke
      atts.merge!(@shape.to_hash)  if @shape
      atts.merge!(@text_record.to_hash)   if @text_record
      atts.merge!(@image_record.to_hash)  if @image_record
      h = {}
      h[klass] =  atts
      h
    end

    def to_yaml
      h = to_hash
      h.to_yaml
    end
    # 
    def save_yaml
      yaml_path = @project_path + "/layout.yml"
      File.open(yaml_path, 'w'){|f| f.write to_yaml}
    end

    def self.from_hash(h)

    end

    def self.from_yaml

    end

    # def overflow?
    #   @overflow == true
    # end
    #
    # def underflow?
    #   @underflow == true
    # end

    def tag=(new_tag)
      @tag = new_tag
      self
    end


    # difference between to_hash and to_data:
    # to_hash does not save values, if they are equal to default
    # to_data save values, even if they are equal to default
    # to_data is used to send the data to view for drawing
    # to_hash is used for archiving, so reduced the size if possible.
    def to_data
      h = {}
      instance_variables.each do |a|
        next if a == @parent
        next if a == @floats
        next if a == @graphics
        v = instance_variable_get a
        s = a.to_s.sub("@","")
        atts[s.to_sym] = v  if !v.nil?
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
      CLASS_NAMES.sample
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

    def mid_point
      [(@x + @width)/2.0, (@y + @height)/2.0]
    end

    def mid_y(rect)
      rect[1] + rect[3]/2
    end

    def max_x(rect)
      rect[0] + rect[2]
    end

    def x_max
      @x + @width
    end

    def x_mid
      @x + @width/2
    end

    def y_max
      @y + @height
    end

    def y_mid
      @y + @height/2
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

    # def intersects_y(rect1, rect2)
    #   (max_y(rect1) > rect2[1] && max_y(rect2) > rect1[1]) || (max_y(rect2) > rect1[1] && max_y(rect1) > rect2[1])
    # end

    def intersects_y(rect1, rect2)
      (max_y(rect1).to_i > rect2[1].to_i && max_y(rect2).to_i > rect1[1].to_i) || (max_y(rect2).to_i > rect1[1].to_i && max_y(rect1).to_i > rect2[1].to_i)
    end

    def intersects_rect(rect_1, rect_2)
      intersects_x(rect_1, rect_2) && intersects_y(rect_1, rect_2)
    end

    def self.random_graphic_atts
      atts = {}
      atts[:fill_color] = RLayout.random_color
      atts[:x]          = Random.new.rand(0..600)
      atts[:y]          = Random.new.rand(0..800)
      atts[:width]      = Random.new.rand(10..200)
      atts[:height]     = Random.new.rand(10..200)
      atts[:line_width] = Random.new.rand(0..10)
      atts[:line_color] = RLayout.random_color
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
          data[:image_path] = File.dirname(__FILE__) + "/../../spec/image/1.jpg"
        end
        samples << Graphic.klass_of(klass_name, data)
      end
      samples
    end

    def self.klass_of(klass, options={})
      case klass
      when "Rectanle"
        Rectangle.new(options)
      when "Circle"
        Circle.new(options)
      when "Ellipse"
        Ellipse.new(options)
      when "RoundRect"
        RoundRect.new(options)
      when "Text"
        Text.new(options)
      else
        Rectangle.new(options)
      end
    end


    def self.with(style_name, &block)
      Graphic.new(Style.shared_style(style_name), &block)
    end

    def relayout!
      return unless @grid_frame
    end

    def frame_rect
      [@x,@y,@width,@height]
    end

    def stroke_rect
      [@x + @left_margin, @y + top_margin ,@width - @left_margin - @right_margin ,@height - @top_margin - @bottom_margin]
    end

    def bounds_rect
      [0,0,@width,@height]
    end

    def fill_rect
      [@x + @left_margin, @y + @top_margin, @width - left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end

    def layout_rect
      [@left_margin, @top_margin, @width - @left_margin - @right_margin - @left_inset - @right_inset, @height - @top_margin - @bottom_margin - @top_inset - @bottom_inset]
    end

    def layout_size
      [@width - @left_margin - @right_margin - @left_inset - @right_inset, @height - @top_margin - @top_inset - @bottom_margin - @bottom_inset]
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
      return false unless @layout_expand
      return true if @layout_expand == :width
      return true if @layout_expand.class == Array && @layout_expand.include?(:width)
      false
    end

    def expand_height?
      return false unless @layout_expand
      return true if @layout_expand == :height
      return true if @layout_expand.class == Array && @layout_expand.include?(:height)
      false
    end


    #/0/0/1/2/0
    def ancestry
      s = ""
      if @parent
        s += @parent.ancestry
        s += "," + @parent.graphics.index(self).to_s
      else
        s = ",0"
      end
      s
    end

    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end

    def save_pdf(path, options={})
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path, options)
      elsif RUBY_ENGINE == 'ruby'
        save_pdf_with_ruby(path, options)
      end
    end

    def save_jpg(path)
      @ns_view ||= GraphicViewMac.from_graphic(self)
      @ns_view.save_jpg(path)
    end

    def bezierPathWithRect(r)
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

    def fit_text_to_box
      @text_layout_manager.fit_text_to_box  if @text_layout_manager
    end
  end
  class NSText < Graphic
    def initialize(options={})
      super
      @transform = options[:transform]
      init_ns_text(options)
      self
    end

    def set_attributed_string(new_att_string)
      return unless @text_layout_manager
      @text_layout_manager.setAttributedString(new_att_string)
    end

    def set_text_string(text_string)
      if RUBY_ENGINE == "rubymotion"
        return unless @text_layout_manager
        @text_layout_manager.set_text_string(text_string)
      else
        @text_record.string = text_string
      end
    end

    def set_text(text_string)
      if RUBY_ENGINE == "rubymotion"
        return unless @text_layout_manager
        @text_layout_manager.set_text_string(text_string)
      else
        @text_record.string = text_string
      end
    end

    def text_string
      if @text_layout_manager
        @text_layout_manager.att_string.string
      elsif @text_record
        @text_record.string
      end
    end

    def font_size
      unless @text_layout_manager
        return 16.0
      else
        @text_layout_manager.font_size
      end
    end

    def setAttributes(atts, range)
      return unless @text_layout_manager
      @text_layout_manager.att_string.setAttributes(atts, range: range)
    end

    def to_pgscript
      if text_string && text_string.length > 0
        variables = "\"#{text_string}\", font_size: #{font_size}, x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height}"
        variables += ", tag: \"#{@tag}\"" if @tag
        "   text(#{variables})\n"
      else
        " "
      end
    end
  end

  class Rectangle < Graphic
    def initialize(options={})
      super
      self
    end

    def to_pgscript
      "   rectangle(x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height})\n"
    end
  end

  class Image < Graphic
    attr_accessor  :bleed, :crop_rect
    def initialize(options={})
      if options[:bleed]
        @bleed = options[:bleed]
      end
      super
      @crop_rect = options[:crop_rect] if options[:crop_rect]
      init_image(options)

      if options[:local_image]
        @local_image = options[:local_image]
      end
      
      if options[:image_path]
        @image_path   = options[:image_path]
        @image_record = ImageStruct.new(options[:image_path])
      elsif options[:image_record]
        @image_record = ImageStruct.new(*options[:image_record])
      end
      self
    end

    def frame_rect
      [@x + @left_margin, @y + @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end


    def to_pgscript
      variables = "x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height}, image_path: \"#{@image_path}\""
      variables += ", tag: \"#{@tag}\"" if @tag
      "   image(#{variables})\n"
    end
  end

  class Circle < Graphic
    def initialize(options={})
      super
      update_shape
      self
    end

    def to_pgscript
      "   circle(x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height})\n"
    end

    def update_shape
      shorter = @width < @height ? @width : @height
      @shape = CircleStruct.new(@x + @width/2, @y + @height/2, shorter/2)
    end
  end

  class Ellipse < Graphic
    def initialize(options={})
      super
      update_shape
      self
    end

    def update_shape
      @shape = EllipseStruct.new((@x+@width)/2, (@y + @height)/2, @width/2, @height/2)
    end
  end

  class RoundRect < Graphic
    def initialize(options={})
      super
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
    attr_accessor :line_type
    #"horizontal_rule", vertical_rule, top_left_to_bottom_right, top_right_to_bottom_left
    def initialize(options={})
      options[:thickness]     = 1 unless options[:thickness] || options[:stroke_thickness] || options[:stroke_width]
      options[:stroke_rule]   = "horizontal_rule" unless options[:stroke_rule]
      super
      self
    end
  end

  class Polygon < Graphic
    def initialize(options={})
      super
      @points= options[:d]
      self
    end
  end

  class Polyline < Graphic
    def initialize(options={})
      super
      @points= options[:points]
      self
    end
  end

  class Path < Graphic
    attr_accessor :d

    def initialize(options={})
      super
      @d= options[:d]
      self
    end
  end
end
