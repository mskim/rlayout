
module RLayout
  
  class Container < Graphic
    attr_accessor :layout_direction, :layout_space, :layout_align
    attr_accessor :grid_base, :grid_width, :grid_height, :grid_frame, :grid_h_gutter, :grid_v_gutter, :lines_in_grid         
    attr_accessor :draw_gutter_stroke, :gutter_stroke #:gutter_stroke_type, :gutter_stroke_width, :gutter_stroke_color, :gutter_stroke_dash
    attr_accessor :floats, :grid #, :main_box
    
    def initialize(parent_graphic, options={}, &block)
      @graphics             = []
      @floats               = options.fetch(:floats, [])
      super      
      @klass                = "Container"
      layout_defaults_hash  = auto_layout_defaults
      @layout_direction     = options.fetch(:layout_direction, layout_defaults_hash[:layout_direction])       
      @layout_space         = options.fetch(:layout_space, layout_defaults_hash[:layout_space])       
      @layout_align         = options.fetch(:layout_align, layout_defaults_hash[:layout_align])       
      @gutter_stroke_color  = options.fetch(:gutter_stroke_color, 'black')   
      @draw_gutter_stroke   = options.fetch(:draw_gutter_stroke, false)
      @gutter_stroke_width  = options.fetch(:gutter_stroke_width, 1)   
      @gutter_stroke_dash   = options.fetch(:gutter_stroke_dash, nil)   
      @gutter_stroke_type   = options.fetch(:gutter_stroke_type, 0)   
      @gutter_stroke        = GutterStrokeStruct.new(@gutter_stroke_color,  @gutter_stroke_width, @gutter_stroke_dash, @gutter_stroke_type) if @draw_gutter_stroke
      init_grid(options)    if options[:grid_base]
      if options[:graphics]
        create_children(options[:graphics])
      end
      if options[:floats]
        create_floats(options[:floats])
      end
      # Container should not process block, when called by subclass as super method.
      # Process block only when block was called from class itself.
      if self.class == Container
        if block
          instance_eval(&block)
        end     
      end     
      self
    end
    
    def auto_layout_defaults
      h = {}
      h[:layout_direction]  = "vertical"
      h[:layout_space]      = 0
      h[:layout_align]      = "top"
      h[:grid_base]         = [3,3]
      h[:grid_color]        = "blue"
      h[:grid_frame]        = [0,0,1,1]
      h[:grid_width]        = 0
      h[:grid_height]       = 0
      h[:grid_show]         = true
      h
    end
    
    def relayout
      if @graphics.length > 0
        relayout!
      end
      # TODO
      # if @floats.length > 0
      #   relayout_grid!
      # end
    end
    
    #TODO
    def graphics_space_sum
      return 0 if @graphics.length == 0
      @layout_space * (@graphics.length-1)
    end
        
    def graphics_height_sum
      return 0 if @graphics.length == 0
      @sum = 0
      @graphics.each {|g| @sum+= g.height + @layout_space}
      return @sum       
    end
    
    def graphics_width_sum
      return 0 if @graphics.length == 0
      @sum = 0
      @graphics.each {|g| @sum+= g.width + @layout_space}
      return @sum 
    end
    
    def save_yml(path)
      h = to_hash
      File.open(path, 'w'){|f| f.write h.to_yaml}
    end
    
    def to_hash 
      h=super
      if @graphics.length > 0
        h[:graphics]= Array.new
        @graphics.each do |child|
          h[:graphics] << child.to_hash
        end
      end
      if @floats && @floats.length > 0
        h[:floats]= Array.new
        @floats.each do |float|
          h[:floats] << float.to_hash
        end
      end
      if @grid
        h[:grid] = @grid.to_hash
      end
      h
    end
        
    def to_data      
      h = {}
      instance_variables.each{|a|
        next if a==@parent_graphic
        next if a==@graphics
        next if a==@floats
        next if a==@fixtures
        v = instance_variable_get a
        s = a.to_s.sub("@","")                        
        h[s.to_sym] = v if !v.nil?
      }
      if @graphics.length > 0
        h[:graphics]= @graphics.map do |child|
          child.to_data
        end
      end
      
      if @floats && @floats.length > 0
        h[:floats]= @floats.map do |child|
          child.to_data
        end
      end
      
      if @fixtures && @fixtures.length > 0
        h[:fixtures]= @fixtures.map do |child|
          child.to_data
        end
      end
      h
    end
    
    def profile
      tags = []
      @graphics.each do |g|
        tags << g.tag if g.tag
      end
      tags.sort!
      tags.join("_")
    end
    
    def to_mongo
      h = to_hash
      h.delete(:graphics)
      h[:_id] = ancestry
      s = h.to_json
      @graphics.each do |graphic|
        s += graphic.to_mongo
      end
      s += "\n"
    end
    
    
    def add_graphic(graphic)
      if graphic.is_a?(Array)
        graphic.each do |item|
          item.parent_graphic = self
          @graphics << item unless @graphics.include?(graphic)
        end
      else
        graphic.parent_graphic = self
        @graphics << graphic unless @graphics.include?(graphic)
      end
    end
    
    def add_floats(float)
      if float.is_a?(Array)
        float.each do |item|
          item.parent_graphic = self
          @floats << item unless @floats.include?(float)
        end
      else
        float.parent_graphic = self
        @floats << float unless @floats.include?(float)
      end
    end
    
    def self.samples_of(number)
      item = []
      number.times do
        item << self.sample
      end
      ad
    end
    
    def self.sample
      ad = AdBox.new(nil) do
        rect(fill_color: random_color)
        rect(fill_color: random_color)
        rect(fill_color: random_color)
      end
      ad
    end
        
    def graphics_with_tag(searching_tag)
      return if searching_tag.nil?
      taged_graphics_array=[]
      @graphics.each do |graphic|
        if graphic.tag == searching_tag.to_s
          taged_graphics_array << graphic 
        end
        
        if graphic.kind_of?(Container)
          taged_graphics_array += graphic.graphics_with_tag(searching_tag) 
        end
      end
      taged_graphics_array
    end
    
    def images_with_tag
      images_array=[]
      @graphics.each do |graphic|
        if graphic.kind_of?(Image) && !@tag.nil?
          images_array<<graphic
        elsif graphic.kind_of?(Container)
          images_array += graphic.images_with_tag
        end
      end
      images_array
    end
    
    def create_graphic_of_type(klass, options={})
      case klass 
      when "Rectangle"
        Rectangle.new(self, options)
      when "Circle"
        Circle.new(self, options)
      when "Text"
        Text.new(self, options)
      when "Image"
        Image.new(self, options)
      when "Line"
        Line.new(self, options)
      when "Container"
        Container.new(self, options)
      when "Matrix"
        Matrix.new(self, options)
      when "ActionBox"
        ActionBox.new(self, options)
      when "AudioBox"
        AudioBox.new(self, options)
      when "MovieBox"
        MovieBox.new(self, options)
      when "SlideBox"
        SlideBox.new(self, options)
      when "WebBox"
        WebBox.new(self, options)
      when "TextRun"
        TextRun.new(self, options)
      when "TextLine"
        TextBar.new(self, options)
      when "TextBox"
        TextBox.new(self, options)
      when "TextColumn"
        TextColumn.new(self, options)
      when "ObjectBox"
        ObjectBox.new(self, options)
      when "ObjectColumn"
        ObjectColumn.new(self, options)
      else 
        puts "Creating Rectangle instead of graphic class named #{klass}!"
        Rectangle.new(self,options)
      end            
    end
    
    # create_children
    def create_children(graphics_hash_array)
      return if graphics_hash_array.nil?
      graphics_hash_array.each do |graphic_hash|
        klass_name=graphic_hash[:klass] 
        create_graphic_of_type(klass_name, graphic_hash)
      end
      relayout!
    end
    
    def create_floats(floats_hash_array)
      return if floats_hash_array.nil?
      @floats = [] if @floats.nil?
      floats_hash_array.each do |float_hash|
        klass_name=float_hash[:klass] 
        float_hash[:is_float] = true
        create_graphic_of_type(klass_name,float_hash)
      end
      # relayout_floats!
    end
    
    ########### pgscript verbes
    def flatten
      
    end
    
    def split_grid(col=12, row=12)
      
    end
    
    
    def split_row(numner=2)
      
    end
    
    def split_col(number=2)
      
    end
    
    def merge_right(number=1)
      
    end
    
    def merge_down(number=1)
      
    end
  end
  
  # Stack is Container with layout_direction set to 'vertical'
  class Stack < Container
    def initialize(parent_graphic, options={}, &block)
      options[:layout_direction] = "vertical"
      super
      @width = 300 unless options[:width]
      self
    end
  end
  
  # Bar is Container with layout_direction set to 'horizontal'
  class Bar < Container
    def initialize(parent_graphic, options={}, &block)
      options[:layout_direction] = "horizontal"
      super
      @width = 300 unless options[:width]
      self
    end
  end
  
  # container with title 
  class TitledBox < Container
    attr_accessor :title, :title_type, :title_position
    
    
  end
  
end