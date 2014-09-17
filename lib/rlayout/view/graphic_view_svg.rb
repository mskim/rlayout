# require File.dirname(__FILE__) + '/graphic_view_svg/line_drawing'
# require File.dirname(__FILE__) + '/graphic_view_svg/fill_drawing'
# require File.dirname(__FILE__) + '/graphic_view_svg/image_drawing'
# require File.dirname(__FILE__) + '/graphic_view_svg/text_drawing'
# require File.dirname(__FILE__) + '/graphic_view_svg/text_drawing'

module RLayout  
  class Graphic
    def leading
      
    end
    
    def ascender
      @font_size
    end
    
    def to_svg
      if @parent_graphic
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
        svg_string += svg
        svg_string += "</svg>\n"
        return svg_string
      end
    end
    
    
    def svg
        s = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\""
        if @fill_color!=nil && @fill_color != ""
          s+= " fill=\"#{@fill_color}\""
        end
        
        if @line_width!=nil && @line_width > 0
          s+= " stroke=\"#{@line_color}\""
          s+= " stroke-width=\"#{@line_width}\""
        end
        s+= "></rect>\n"
        
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y}\" fill=\"#{@text_color}\">#{@text_string}</text>\n"
        end
        s
    end
    
  end
  
  class Circle < Graphic
    def svg
      r = (@width <= @height) ? @width/2 : @height/2
      s = "<circle cx=\"#{@x+@width/2}\" cy=\"#{@y+@height/2}\" r=\"#{r}\""
      if @fill_color!=nil && @fill_color != ""
        s+= " fill=\"#{@fill_color}\""
      end
      if @line_width!=nil && @line_width > 0
        s+= " stroke=\"#{@line_color}\""
        s+= " stroke-width=\"#{@line_width}\""
      end
      s+= "></circle>\n"      
    end
  end
  
  class RoundRect < Graphic
    def svg
      shorter=(@width <= @height) ? @width : @height
      r=shorter*0.1
      s = "<rect x=\"#{@x}\" y=\"#{@y}\"  rx=\"#{r}\" ry=\"#{r}\" width=\"#{@width}\" height=\"#{@height}\""
      if @fill_color!=nil && @fill_color != ""
        s+= " fill=\"#{@fill_color}\""
      end
      if @line_width!=nil && @line_width > 0
        s+= " stroke=\"#{@line_color}\""
        s+= " stroke-width=\"#{@line_width}\""
      end
      s+= "></rect>\n"
    end
  end
  
  class TextToken
    def svg

        s = ""
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y + @height*0.8}\">#{@text_string}</text>\n"
        
        end
        s
    end
  end
  class Container < Graphic
    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" class=\"#{@klass}\" x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\">\n"
      @graphics.each do |graphic|
        s += graphic.to_svg
      end
      s += "</svg>\n"      
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
  end
  
end
