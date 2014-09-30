
require File.dirname(__FILE__) + "/container/pgscript"
module RLayout
  
  class Container < Graphic
    attr_accessor :layout_mode     # layout_mode: "auto_layout" "grid"
    attr_accessor :layout_direction, :layout_strarting, :layout_space, :layout_align
    attr_accessor :grid_column_count, :grid_row_count, :grid_cells, :grid_v_lines, :grid_h_lines, :grid_color, :show_grid
    attr_accessor :grid_rect, :grid_inset, :grid_top_inset, :grid_bottom_inset, :grid_letf_inset, :grid_right_inset
    attr_accessor :unit_grid_width, :unit_grid_height, :frame
    attr_accessor :gutter_line_type, :gutter_line_width, :gutter_line_color, :gutter_line_dash
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass            = "Container"
      @graphics         = options.fetch(:graphics, []) 
      layout_defaults_hash = layout_defaults
      @layout_mode      = options.fetch(:layout_mode, layout_defaults_hash[:layout_mode])
      @layout_direction = options.fetch(:layout_direction, layout_defaults_hash[:layout_direction])       
      @layout_strarting = options.fetch(:layout_strarting, layout_defaults_hash[:layout_strarting])       
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
      @unit_grid_width  = options.fetch(:unit_grid_width, layout_defaults_hash[:unit_grid_width])       
      @unit_grid_height = options.fetch(:unit_grid_height, layout_defaults_hash[:unit_grid_height])       
      @show_grid        = options.fetch(:show_grid, layout_defaults_hash[:show_grid])

      @gutter_line_type = options[:gutter_line_type]     
      @gutter_line_width= options[:gutter_line_width]
      @gutter_line_color= options[:gutter_line_color]
      @gutter_line_dash = options[:gutter_line_dash]
      
      @floats           = options[:floats]
      
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
      h[:grid_rect]        = [0,0,1,1]
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
    
    def to_data
      h = {}
      instance_variables.each{|a|
        s = a.to_s
        next if s=="@parent_graphic"
        next if s=="@graphics"
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil?
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
    
    
    # def relayout!
    #   # puts __method__
    #   
    # end
    
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