COLOR_NAMES =%w[black blue brown clear cyan darkGray gray green lightGray magenta orange purple red white yellow]
COLOR_LIST = {"AliceBlue"=>"#F0F8FF", "AntiqueWhite"=>"#FAEBD7", "Aqua"=>"#00FFFF", "Aquamarine"=>"#7FFFD4", "Azure"=>"#F0FFFF", "Beige"=>"#F5F5DC", "Bisque"=>"#FFE4C4", "Black"=>"#000000", "BlanchedAlmond"=>"#FFEBCD", "Blue"=>"#0000FF", "BlueViolet"=>"#8A2BE2", "Brown"=>"#A52A2A", "BurlyWood"=>"#DEB887", "CadetBlue"=>"#5F9EA0", "Chartreuse"=>"#7FFF00", "Chocolate"=>"#D2691E", "Coral"=>"#FF7F50", "CornflowerBlue"=>"#6495ED", "Cornsilk"=>"#FFF8DC", "Crimson"=>"#DC143C", "Cyan"=>"#00FFFF", "DarkBlue"=>"#00008B", "DarkCyan"=>"#008B8B", "DarkGoldenRod"=>"#B8860B", "DarkGray"=>"#A9A9A9", "DarkGreen"=>"#006400", "DarkKhaki"=>"#BDB76B", "DarkMagenta"=>"#8B008B", "DarkOliveGreen"=>"#556B2F", "DarkOrange"=>"#FF8C00", "DarkOrchid"=>"#9932CC", "DarkRed"=>"#8B0000", "DarkSalmon"=>"#E9967A", "DarkSeaGreen"=>"#8FBC8F", "DarkSlateBlue"=>"#483D8B", "DarkSlateGray"=>"#2F4F4F", "DarkTurquoise"=>"#00CED1", "DarkViolet"=>"#9400D3", "DeepPink"=>"#FF1493", "DeepSkyBlue"=>"#00BFFF", "DimGray"=>"#696969", "DodgerBlue"=>"#1E90FF", "FireBrick"=>"#B22222", "FloralWhite"=>"#FFFAF0", "ForestGreen"=>"#228B22", "Fuchsia"=>"#FF00FF", "Gainsboro"=>"#DCDCDC", "GhostWhite"=>"#F8F8FF", "Gold"=>"#FFD700", "GoldenRod"=>"#DAA520", "Gray"=>"#808080", "Green"=>"#008000", "GreenYellow"=>"#ADFF2F", "HoneyDew"=>"#F0FFF0", "HotPink"=>"#FF69B4", "IndianRed "=>"#CD5C5C", "Indigo "=>"#4B0082", "Ivory"=>"#FFFFF0", "Khaki"=>"#F0E68C", "Lavender"=>"#E6E6FA", "LavenderBlush"=>"#FFF0F5", "LawnGreen"=>"#7CFC00", "LemonChiffon"=>"#FFFACD", "LightBlue"=>"#ADD8E6", "LightCoral"=>"#F08080", "LightCyan"=>"#E0FFFF", "LightGoldenRodYellow"=>"#FAFAD2", "LightGray"=>"#D3D3D3", "LightGreen"=>"#90EE90", "LightPink"=>"#FFB6C1", "LightSalmon"=>"#FFA07A", "LightSeaGreen"=>"#20B2AA", "LightSkyBlue"=>"#87CEFA", "LightSlateGray"=>"#778899", "LightSteelBlue"=>"#B0C4DE", "LightYellow"=>"#FFFFE0", "Lime"=>"#00FF00", "LimeGreen"=>"#32CD32", "Linen"=>"#FAF0E6", "Magenta"=>"#FF00FF", "Maroon"=>"#800000", "MediumAquaMarine"=>"#66CDAA", "MediumBlue"=>"#0000CD", "MediumOrchid"=>"#BA55D3", "MediumPurple"=>"#9370DB", "MediumSeaGreen"=>"#3CB371", "MediumSlateBlue"=>"#7B68EE", "MediumSpringGreen"=>"#00FA9A", "MediumTurquoise"=>"#48D1CC", "MediumVioletRed"=>"#C71585", "MidnightBlue"=>"#191970", "MintCream"=>"#F5FFFA", "MistyRose"=>"#FFE4E1", "Moccasin"=>"#FFE4B5", "NavajoWhite"=>"#FFDEAD", "Navy"=>"#000080", "OldLace"=>"#FDF5E6", "Olive"=>"#808000", "OliveDrab"=>"#6B8E23", "Orange"=>"#FFA500", "OrangeRed"=>"#FF4500", "Orchid"=>"#DA70D6", "PaleGoldenRod"=>"#EEE8AA", "PaleGreen"=>"#98FB98", "PaleTurquoise"=>"#AFEEEE", "PaleVioletRed"=>"#DB7093", "PapayaWhip"=>"#FFEFD5", "PeachPuff"=>"#FFDAB9", "Peru"=>"#CD853F", "Pink"=>"#FFC0CB", "Plum"=>"#DDA0DD", "PowderBlue"=>"#B0E0E6", "Purple"=>"#800080", "RebeccaPurple"=>"#663399", "Red"=>"#FF0000", "RosyBrown"=>"#BC8F8F", "RoyalBlue"=>"#4169E1", "SaddleBrown"=>"#8B4513", "Salmon"=>"#FA8072", "SandyBrown"=>"#F4A460", "SeaGreen"=>"#2E8B57", "SeaShell"=>"#FFF5EE", "Sienna"=>"#A0522D", "Silver"=>"#C0C0C0", "SkyBlue"=>"#87CEEB", "SlateBlue"=>"#6A5ACD", "SlateGray"=>"#708090", "Snow"=>"#FFFAFA", "SpringGreen"=>"#00FF7F", "SteelBlue"=>"#4682B4", "Tan"=>"#D2B48C", "Teal"=>"#008080", "Thistle"=>"#D8BFD8", "Tomato"=>"#FF6347", "Turquoise"=>"#40E0D0", "Violet"=>"#EE82EE", "Wheat"=>"#F5DEB3", "White"=>"#FFFFFF", "WhiteSmoke"=>"#F5F5F5", "Yellow"=>"#FFFF00", "YellowGreen"=>"#9ACD32"}

module RLayout
  module_function
  
  def random_color
    COLOR_LIST.keys.sample
  end
  # color2rgb('lightGray)
  # => [0, 61, 61]
  # color2rgb('orange)
  # => [0, 250, 80]
  def color2rgb(name)
    unless COLOR_LIST[upcase_first_letter(name)]
      return hex2rgb(COLOR_LIST['Black'])
    end
    hex2rgb(COLOR_LIST[upcase_first_letter(name)])
  end
  
  # color2rgb('lightGray)
  # => #D3D3D3
  # color2rgb('orange)
  # => #FFA500
  def color2hex(name)
    unless COLOR_LIST[upcase_first_letter(name)]
      return COLOR_LIST['Black']
    end
    COLOR_LIST[upcase_first_letter(name)]
  end
  
  def rgb2hex(rgb)
    rgb.map { |e| "%02x" % e }.join
  end

  # Converts hex string into RGB value array:
  #
  #  hex2rgb("ff7808")
  #  => [255, 120, 8]
  #
  def hex2rgb(hex)
    r,g,b = hex[0..1], hex[2..3], hex[4..5]
    [r,g,b].map { |e| e.to_i(16) }
  end
  
  def upcase_first_letter(name)
    name[0] = name[0].upcase
    name
  end
end
# puts capitalize_first('lightGray')
# puts RLayout::color2hex('lightGray')
# puts RLayout::random_color