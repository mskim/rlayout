#!/usr/local/bin/macruby
framework 'cocoa'

fm=NSFontManager.sharedFontManager
font_list=fm.availableFonts
# puts font_list.length
for font in font_list do
  puts font
  my_font=NSFont.fontWithName(font, :size=>24)
  # puts my_font.fontDescriptor
  # puts my_font.numberOfGlyphs
  # font_set= my_font.coveredCharacterSet
  # puts my_font.boundingRectForFont
  # puts my_font.boundingRectForGlyph(33)
  # puts font_set
  # puts "my_font.descender:#{my_font.descender}"
  # puts "my_font.displayName:#{my_font.displayName}"
  # puts "my_font.boundingRectForGlyph:#{my_font.boundingRectForGlyph(33)}"
  
end
# appendBezierPathWithGlyph:inFont:
# [path appendBezierPathWithGlyph:(NSGlyph)glyphCodes[i] inFont:font];
# NSBezierPath *path = [NSBezierPath bezierPath];

# my_font=NSFont.fontWithName("YGO31", :size=>24)
# bp= NSBezierPath.bezierPath
# a_point=NSPoint.new(10,10)
# bp.moveToPoint(a_point)
# bp= bp.appendBezierPathWithGlyph(32, :inFont=>my_font)