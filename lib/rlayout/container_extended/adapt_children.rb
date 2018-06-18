module RLayout
  
  
  class Container
    
    def adopt_children
      @parents.graphics.each do |graphic|
        if in_my_area?(graphic)
          adap_graphic(graphic)
        end
      end
    end
    
    def in_my_area?(graphic)
      contains_rect(rect, graphic.rect)
    end
    
    def adapt_graphic(graphic)
      @parents.delete(graphic)
      graphic.parent = self
      @graphics << graphic
    end
    
    # construct lines with in the container 
    # look for TextTokens and form a lines
    # look for horizontally spread tokens within about the size of space character
    def construct_lines
      
    end
    
    def construct_columns
      
    end
    
    def construct_text_box
      
    end
  end
  
end