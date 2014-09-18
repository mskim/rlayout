
framework 'cocoa'

if RUBY_ENGINE == "macruby"
  framework 'cocoa'
  fonts = NSFontManager.sharedFontManager.availableFontFamilies
  puts fonts.include?("AppleGothic")
  puts fonts.containsObject("AppleGothic")
  # puts "fonts:#{fonts}"
  puts fonts.include?("Times")
  puts fonts.include?("Helvetica")

end


def make_font_with_table(font_object, string)
  atts={}
  atts[NSFontAttributeName] = font_object #NSFont.fontWithName(font, size:1000)
  att_string=NSMutableAttributedString.alloc.initWithString(string, attributes:atts)
  att_string.size if att_string
end


def get_font_info(font_name)
  font_object = NSFont.fontWithName(font_name, size:1000)
  unless font_object
    puts "#{font_name} not found!"
    return Hash.new
  end
  
  width_array = []
  (0..255).each do |i|
    # puts i.chr
    width_array << make_font_with_table(font_object, i.chr).width
  end
  info = {}
  info[:acender]    = font_object.ascender
  info[:descender]   = font_object.descender
  info[:leading]     = font_object.leading
  info[:width_array] = width_array
  info
end

font_names = %w[AppleGothic Times Helvetica]
font_lookup_table = {}
font_names.each do |font_name|
  font_lookup_table[font_name] = get_font_info(font_name)
end 
puts font_lookup_table
