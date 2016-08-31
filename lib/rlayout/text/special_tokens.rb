
module RLayout
  
  class Paragraph < Container
    def box(text, options={})
      para_style = @para_style.dup
      para_style[:text_string] = text
      para_style[:stroke_width] = 0.5
      @tokens << TextToken.new(para_style)
    end
    
    def round(text, options={})
      para_style = @para_style.dup
      para_style[:text_string] = text
      para_style[:stroke_width] = 0.5
      para_style[:shape]        = "round"
      @tokens << TextToken.new(para_style)
    end
  end
  
end