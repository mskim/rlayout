# Calculating token width using HexaPDF

## make style as publication 

def self.style(style_name)
  case style_name
  when 'body'
    @body ||= Style.new()
  when 'title'
    @main_title ||= Style.new(style_name)
  end
end

def ruby_style(style_name)

end

1. Create HexaPDF::Layout::Style
  @para_style
2. Convert stirng to glyph
  @style.decode_utf8(stirng))

3. get sum of item width
   #   @width ||= @items.sum {|item| style.scaled_item_width(item) }

