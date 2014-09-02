
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
    attr_accessor :grid_column, :grid_row, :grid_column_gutter, :grid_row_gutter
    
    def initialize(parent_graphic, options={}, &block)
      super

      @graphics         = options.fetch(:graphics, [])      
      @layout_mode      = options.fetch(:layout_mode, defaults[:layout_mode])
      @layout_direction = options.fetch(:layout_direction, defaults[:layout_direction])       
      @layout_strarting = options.fetch(:layout_strarting, defaults[:layout_strarting])       
      @layout_space     = options.fetch(:layout_space, defaults[:layout_space])       
      @layout_align     = options.fetch(:layout_align, defaults[:layout_align])       
      
      if block
        instance_eval(&block)
      end
      self
    end
    
    def defaults
      h = super
      h[:layout_mode]       = "auto_layout"
      h[:layout_direction]  = "vertical"
      h[:layout_strarting]  = "top"
      h[:layout_space]      = 0
      h[:layout_align]      = "top"
      h
    end
    
    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{width}\" height=\"#{height}\">\n"
      @graphics.each do |graphics|
        s += graphics.to_svg
      end
      s += "</svg>"      
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    def rect(options={})
      @graphics << Rectangle.new(self, options)
    end
    
    def circle(options={})
      @graphics << Circle.new(self, options)
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
  
  class Heading < Container
  
    def title
    end
    
    def author
    end
    
    def subtitle
    end
    
    def leading
      
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