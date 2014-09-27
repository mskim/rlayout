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
#  place(graphic, [grid_x,grid_y,grid_with,grid_height])
#  place(graphic_arry, [grid_x,grid_y,grid_with,grid_height])


module RLayout
  class Container < Graphic
    
    def rect(options={})
      Rectangle.new(self, options)
    end
    
    def text(options={})
      Text.new(self, options)
    end
    
    def circle(options={})
      Circle.new(self, options)
    end
    
    def container(options={}, &block)
      Container.new(self, options, &block)
    end
    
    def random_graphics(number)
      add_graphics(Graphic.random_graphics(number))
    end
    
    def split(number=2, options={})
      @layout_direction = options.fetch(:layout_direction, "vertical")
      if options[:layout_space]
        # layout_space applies to self, not to children
        @layout_space = options[:layout_space]
        options.delete(:layout_space)
      end
      
      if number.class == Fixnum
        number.times do
          # puts "options:#{options}"
          Container.new(self, options)
        end
      elsif number.class == Array
        number.each do |attribute|
          if attribute.class == Fixnum
            
          elsif attribute.class == Hash
            
          end
        end
      
      end
      relayout!
      
    end
    
    # set layout_direction = "vertical"
    def split_v(number=2, options={})
      options[:layout_direction] = "vertical"
      split(number, options)
    end
    
    # layout_direction = "horizontal"
    def split_h(number=2, options={})
      options[:layout_direction] = "horizontal"
      split(number, options)
      
    end
    
    # set layout_mode as grid"
    # options[:base_grod] sets grid base
    def place(grid_frame, options={})
      # This layout_mode = grid_matrix
      # if graphic.is_a?(Array)
      #   graphic.each do |item|
      #     item.parent_graphic = self
      #     @graphics << item unless @graphics.include?(graphic)
      #   end
      # else
      #   graphic.parent_graphic = self
      #   @graphics << graphic unless @graphics.include?(graphic)
      # end
      
    end
    
    # it should go to graphics
    # def page
    #   
    # end
    # 
    # def document
    #   
    # end
    
    def syblings
      
    end
    
    def child_at(node_tree)
      
    end
    
    def children
      
    end
    
    def decendents
      
    end
    
    def decendents_at(node_tree)
      
    end
  end
  
  
  
end