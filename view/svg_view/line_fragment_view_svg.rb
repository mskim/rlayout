module RLayout
  class LineFragment
    def to_svg
      s = ""
      if @parent_graphic
        text_color_string = ""
        text_color_string += "fill_color: #{@text_color}" if @text_color
        font_size = @font_size || 10
        s = "<text x='#{@x}' y='#{@y + font_size}' style='font-size:#{font_size};#{text_color_string}'>"
        s += line_string
        s +='</text>'
      else
        s= puts "line without pararent_graphics"
      end
      s
    end

    #TODO
    def line_tspan_string
      #code
    end

    def children_graphics_svg
      # draw container stuff
      # draw children stuff
      s = ""
      @graphics.each do |token|
        s += "<tspan x='#{token.x}'>#{token.string}</tspan>"
      end
      s
    end

  end

end
