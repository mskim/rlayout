
module RLayout
  class RTextToken < Graphic
    def draw_text_in_ruby(canvas)
      if @string.length > 0 && @para_style
        font_name = @para_style[:font] 
        size = @para_style[:font_size]
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
            # ################## bug here
            # font size not changed 
              canvas.font(canvas.font, size: size)
          else
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{font_name}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          end
        else
          size = @para_style[:font_size] || 16
          # canvas.font(font_wapper, size: size)
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/Shinmoon.ttf"
          font_file     = font_foleder + "/#{font_name}.ttf" if font_name
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: size)
        end
        f = flipped_origin
        x_offset = f[0]
        y_offset = f[1] + 3
        #TODO
        canvas.text(@string, at: [x_offset, y_offset + @y])
      end
    end
  end
end