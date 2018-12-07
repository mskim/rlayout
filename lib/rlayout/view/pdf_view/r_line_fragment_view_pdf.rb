module RLayout
  class RLineFragment < Container
  
    
    def draw_text_in_ruby(canvas)
      if @graphics.length > 0
        font_name = @para_style[:font] 
        size = @para_style[:font_size]

        if @pareant && @pareant.parent && @pareant.parent.class == RLayout::TitleText #&& @parent.class == RLayout::NewsArticleBox
          @flipped = flipped_origin
          @stroke.color = 'CMYK=0,0,0,100'
          @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String
          canvas.stroke_color(@stroke.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).stroke
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
          size = @para_style[:font_size] || 16
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

        @graphics.each do |token|
          canvas.text(token.string, at: [x + token.x, y])
        end
      end
    end
  end
end