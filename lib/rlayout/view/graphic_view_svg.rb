
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
        svg_string += "\n</svg>\n"
        return svg_string
      end
    end
    
    
    def svg      
      s = @shape.to_svg 
      s = s.gsub!("replace_this_with_style", svg_style)
      s += @image_record.to_svg.gsub!("replace_this_with_rect", svg_rect) if @image_record
      s += @text_record.to_svg.gsub!("replace_this_with_text_origin", svg_text_origin) if @text_record
      s
    end
    
    def svg_style
      "style=\"fill:#{@fill.color};#{@stroke.to_svg}\""
    end
    
    def svg_rect
      "x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{height}\""
    end
    
    def svg_text_origin
      size = @text_record.size || 16
      "x=\"#{@x}\" y=\"#{@y + size*1.2}\""
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
  end
  


  class Container < Graphic
    
    def to_svg
      if @parent_graphic
        s = svg + "\n"
        s += children_graphics_svg
      else
        s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{@x + @width}px\" height=\"#{@y + @height}px\">\n"
        s += svg + "\n"        
        s += children_graphics_svg
        s += "</svg>\n"
      end
      s
    end
    
    def children_graphics_svg
      # draw container stuff
      # draw children stuff
      s = "<g transform=\"translate(#{@x},#{@y})\">\n"
      @graphics.each do |graphic|
        s += graphic.to_svg
      end
      s +="</g>\n"
      s 
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
  end
  
  class TextToken
    def svg
      
      # TODO Line Fill Shape Image & Text
      
      s = ""
      if @text_string !=nil && @text_string != ""
        s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y + @height*0.8}\">#{@text_string}</text>\n"
      end
      s
    end
  end
end
