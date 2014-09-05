# PageScript Verbs
#  h1
#  h2
#  h3
#  h4
#  h5
#  p
#  image
#  rect
#  circle
#  round_rect
#  line
#  set_layout_mode
#  set_grid_base
#  place(graphic, grid_x,grid_y,grid_with,grid_height)


# Layout 
#  place_graphic 
#  implied that graphic is added at specified location
#  Graphic should have x,y,width,height or grid_x,grid_y,grid_width,grid_height
#  
#  stack_graphic 
#  implies the graphic is stacked at the end of the stack. 
#  Location and the size is auto-layed out 
#  Size can be set by "unit_length", which is relative size to others in the stack.
#  They can be set in two different layers or they can reside in the same layer.
#  There is a special case, where some graphic sits in stack layout

module RLayout
  
  class Container < Graphic
    attr_accessor :graphics
    attr_accessor :layout_mode     # layout_mode: "auto_layout" "grid"
    attr_accessor :layout_direction, :layout_strarting, :layout_space, :layout_align
    attr_accessor :grid_column_count, :grid_row_count, :grid_cells, :grid_v_lines, :grid_h_lines, :grid_color, :show_grid
    attr_accessor :grid_frame, :grid_inset, :grid_top_inset, :grid_bottom_inset, :grid_letf_inset, :grid_right_inset
    attr_accessor :unit_grid_width, :unit_grid_height, :frame
    attr_accessor :gutter_line_type, :gutter_line_width, :gutter_line_color, :gutter_line_dash
    
    def initialize(parent_graphic, options={}, &block)
      super
      @graphics         = options.fetch(:graphics, [])      
      @layout_mode      = options.fetch(:layout_mode, layout_defaults[:layout_mode])
      @layout_direction = options.fetch(:layout_direction, layout_defaults[:layout_direction])       
      @layout_strarting = options.fetch(:layout_strarting, layout_defaults[:layout_strarting])       
      @layout_space     = options.fetch(:layout_space, layout_defaults[:layout_space])       
      @layout_align     = options.fetch(:layout_align, layout_defaults[:layout_align])       
            
      @grid_cells       = options.fetch(:grid_cells, layout_defaults[:grid_cells])       
      @grid_column_count= options.fetch(:grid_column_count, layout_defaults[:grid_column_count])       
      @grid_row_count   = options.fetch(:grid_row_count, layout_defaults[:grid_row_count])       
      @grid_v_lines     = options.fetch(:grid_v_lines, layout_defaults[:grid_v_lines])       
      @grid_h_lines     = options.fetch(:grid_h_lines, layout_defaults[:grid_h_lines])       
      @grid_color       = options.fetch(:grid_color, layout_defaults[:grid_color])       
      @grid_inset       = options.fetch(:grid_inset, layout_defaults[:grid_inset])       
      @grid_top_inset   = options.fetch(:grid_top_inset, layout_defaults[:grid_top_inset])       
      @grid_bottom_inset= options.fetch(:grid_bottom_inset, layout_defaults[:grid_bottom_inset])       
      @grid_letf_inset  = options.fetch(:grid_letf_inset, layout_defaults[:grid_letf_inset])       
      @grid_right_inset = options.fetch(:grid_right_inset, layout_defaults[:grid_right_inset])       
      @unit_grid_width  = options.fetch(:unit_grid_width, layout_defaults[:unit_grid_width])       
      @unit_grid_height = options.fetch(:unit_grid_height, layout_defaults[:unit_grid_height])       
      @show_grid        = options.fetch(:show_grid, layout_defaults[:show_grid])

      @gutter_line_type = options[:gutter_line_type]     
      @gutter_line_width= options[:gutter_line_width]
      @gutter_line_color= options[:gutter_line_color]
      @gutter_line_dash = options[:gutter_line_dash]
      
      if @layout_mode == "grid"
        # @unit_grid_width    = @owner_graphic.drawing_area[SIZE_WIDTH]/@grid_column_count 
        # @unit_grid_height   = @owner_graphic.drawing_area[SIZE_HEIGHT]/@grid_row_count 
        update_grids
      end
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    def layout_defaults
      h = {}
      h[:layout_mode]       = "auto_layout"
      h[:layout_direction]  = "vertical"
      h[:layout_strarting]  = "top"
      h[:layout_space]      = 0
      h[:layout_align]      = "top"
      h[:grid_cells]        = Array.new
      h[:grid_column_count] = 6
      h[:grid_row_count]    = 6
      h[:grid_v_lines]      = Array.new
      h[:grid_h_lines]      = Array.new
      h[:grid_color]        = "blue"
      h[:grid_frame]        = [0,0,1,1]
      h[:grid_inset]        = [0,0,0,0]
      h[:unit_grid_width]   = 0
      h[:unit_grid_height]  = 0
      h[:show_grid]         = true
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
    
    def layout_area
      [@width - @left_margin - @right_margin - @left_inset - @right_inset, @height - @top_margin - @top_inset - @bottom_margin - @bottom_inset]
    end
    
    def to_hash
      h = {}
      instance_variables.each{|a|
        s = a.to_s
        next if s=="@parent_graphic"
        next if s=="@graphics"
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil? && v !=defaults[n.to_sym] && v !=layout_defaults[n.to_sym]
      }
      if @graphics.length > 0
        h[:graphics]= @graphics.map do |child|
          child.to_hash
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
    
    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\">\n"
      @graphics.each do |graphics|
        s += graphics.to_svg
      end
      s += "</svg>\n"      
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    def rect(options={})
      Rectangle.new(self, options)
    end
    
    def circle(options={})
      Circle.new(self, options)
    end
    
    
    def add_graphic(graphic, layout_mode="stack")
      
    end
    
    def place_graphic(graphic)
      graphic.parent_graphic = self
      unless @graphics.include?(graphic)
        @graphics << graphic 
      end
    end
    
    
    def stack_graphic(graphic)
      graphic.parent_graphic = self
      unless @graphics.include?(graphic)
        @graphics << graphic 
        relayout!
      end
    end
    
    def change_stack_direction
      
    end
    
    def relayout!
      # puts __method__
      
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
  
  
  class Body < Container
    attr_accessor :columns, :drws_interline, :gutter
    def initialize(parent_graphic, options={})
      super
      @columns = []
      @column_count = options.fetch(:columns, 2)
      @column_count.times do
        @columns << Container.new(self)
      end
      self
    end
  end
end