
module RLayout
  
  class Container < Graphic
    attr_accessor :layout_mode     # layout_mode: "auto_layout" "grid"
    attr_accessor :layout_direction, :layout_space, :layout_align
    attr_accessor :grid_column_count, :grid_row_count, :grid_cells, :grid_v_lines, :grid_h_lines, :grid_color, :grid_show
    attr_accessor :grid_rect, :grid_inset, :grid_top_inset, :grid_bottom_inset, :grid_letf_inset, :grid_right_inset
    attr_accessor :grid_unit_width, :grid_unit_height, :grid_frame
    attr_accessor :gutter_line_type, :gutter_line_width, :gutter_line_color, :gutter_line_dash
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass            = "Container"
      @graphics         = []
      layout_defaults_hash = auto_layout_defaults
      @layout_mode      = options.fetch(:layout_mode, layout_defaults_hash[:layout_mode])
      @layout_direction = options.fetch(:layout_direction, layout_defaults_hash[:layout_direction])       
      @layout_space     = options.fetch(:layout_space, layout_defaults_hash[:layout_space])       
      @layout_align     = options.fetch(:layout_align, layout_defaults_hash[:layout_align])       
      @grid_cells       = options.fetch(:grid_cells, layout_defaults_hash[:grid_cells])       
      @grid_column_count= options.fetch(:grid_column_count, layout_defaults_hash[:grid_column_count])       
      @grid_row_count   = options.fetch(:grid_row_count, layout_defaults_hash[:grid_row_count])       
      @grid_v_lines     = options.fetch(:grid_v_lines, layout_defaults_hash[:grid_v_lines])       
      @grid_h_lines     = options.fetch(:grid_h_lines, layout_defaults_hash[:grid_h_lines])       
      @grid_color       = options.fetch(:grid_color, layout_defaults_hash[:grid_color])       
      @grid_inset       = options.fetch(:grid_inset, layout_defaults_hash[:grid_inset])       
      @grid_top_inset   = options.fetch(:grid_top_inset, layout_defaults_hash[:grid_top_inset])       
      @grid_bottom_inset= options.fetch(:grid_bottom_inset, layout_defaults_hash[:grid_bottom_inset])       
      @grid_letf_inset  = options.fetch(:grid_letf_inset, layout_defaults_hash[:grid_letf_inset])       
      @grid_right_inset = options.fetch(:grid_right_inset, layout_defaults_hash[:grid_right_inset])       
      @grid_unit_width  = options.fetch(:grid_unit_width, layout_defaults_hash[:grid_unit_width])       
      @grid_unit_height = options.fetch(:grid_unit_height, layout_defaults_hash[:grid_unit_height])       
      @grid_show        = options.fetch(:grid_show, layout_defaults_hash[:grid_show])
      @gutter_line_type = options[:gutter_line_type]     
      @gutter_line_width= options[:gutter_line_width]
      @gutter_line_color= options[:gutter_line_color]
      @gutter_line_dash = options[:gutter_line_dash]
      @floats           = options[:floats]
      if options[:graphics]
        create_children(options[:graphics])
      end
      
      if @layout_mode == "grid"
        update_grids
      end      
      if block
        instance_eval(&block)
      end      
      self
    end
    
    def auto_layout_defaults
      h = {}
      h[:layout_mode]       = "auto_layout"
      h[:layout_direction]  = "vertical"
      h[:layout_space]      = 0
      h[:layout_align]      = "top"
      h[:grid_cells]        = Array.new
      h[:grid_column_count] = 6
      h[:grid_row_count]    = 6
      h[:grid_v_lines]      = Array.new
      h[:grid_h_lines]      = Array.new
      h[:grid_color]        = "blue"
      h[:grid_rect]        = [0,0,1,1]
      h[:grid_inset]        = [0,0,0,0]
      h[:grid_unit_width]   = 0
      h[:grid_unit_height]  = 0
      h[:grid_show]         = true
      h
    end
    
    def relayout
      return unless @graphics.length > 0
      if @layout_mode == "auto_layout"
        relayout!
      elsif @layout_mode == "grid"
        relayout_grid!
      end
    end
    
    #TODO
    def graphics_space_sum
      return 0 if @graphics.length == 0
      @layout_space * (@graphics.length-1)
    end
    
    def layout_area
      [@width - @left_margin - @right_margin - @left_inset - @right_inset, @height - @top_margin - @top_inset - @bottom_margin - @bottom_inset]
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
        h[:graphics]=[]
        @graphics.each do |child|
          h[:graphics] << child.to_hash
        end
      end
      if @floats && @floats.length > 0
        h[:floats]=[]
        @floats.each do |float|
          h[:floats] << float.to_hash
        end
      end
      
      # if @fixtures && @fixtures.length > 0
      #   h[:fixtures]=[]
      #   @fixtures.each do |fixture|
      #     h[:fixtures] << fixture.to_hash
      #   end
      # end
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
    
    
    def add_graphics(graphic)
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
      when "StoryBox"
        StoryBox.new(self, options)
      when "StoryColumn"
        StoryColumn.new(self, options)
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
        create_graphic_of_type(klass_name,graphic_hash)
      end
      relayout!
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
  
  # container with title 
  class TitledBox < Container
    attr_accessor :title, :title_type, :title_position
    
    
  end
  
end