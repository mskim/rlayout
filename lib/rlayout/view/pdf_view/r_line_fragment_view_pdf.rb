module RLayout
  class RLineFragment < Container
  
    def draw_body_line(canvas)
      if @graphics.length > 0
        if @para_style
          font_name = @para_style[:font] || 'Shinmoon' 
          size = @para_style[:font_size]  || '9.5'
        else
          font_name = 'Shinmoon' 
          size = '9.5'
        end

        if canvas.font
          canvase_font_name = canvas.font.wrapped_font.font_name
          canvas_font_size = canvas.font_size
          if font_name == canvase_font_name && size == canvas_font_size
          elsif font_name != canvase_font_name
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          elsif size != canvas_font_size
            canvas.font(canvas.font, size: size)
          else
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          end
        else
          size = 9.5 # TODO
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/Shinmoon.ttf"
          font_file     = font_foleder + "/#{font_name}.ttf" if font_name
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: size)
        end

        f = @parent.flipped_origin
        y_offset = @parent.height
        @graphics.each do |token|
          # TODO considder drawing position, lowe by token height?
          canvas.text(token.string, at: [token.x, f[1] - y])
        end
      end
    end
  end
end