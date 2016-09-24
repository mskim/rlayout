
module  RLayout
  module_function
  
  def round_rect_to_three(rect)
    new_rect = rect.dup
    new_rect.origin.x.round(3)
    new_rect.origin.y.round(3)
    new_rect.size.width.round(3)
    new_rect.size.height.round(3)
    new_rect
  end
  
  def nsrect2array(ns_rect)
     [ns_rect.origin.x,ns_rect.origin.y,ns_rect.size.width,ns_rect.size.height]
  end
  
  def nsrect2string(ns_rect)
    nsrect2array(ns_rect).to_s
  end
  
  def array2nsrect(array)
    NSRect.new(NSPoint.new(array[0],array[1]), NSSize.new(array[2],array[3]))
  end
  
  def nspoint2array(ns_point)
    [ns_point.x, ns_point.y]
  end
  
  def array2nspoint(array)
    NSPoint.new(array[0],array[1])
  end
  
  def min_x(rect)
    rect[0]
  end

  def min_y(rect)
    rect[1]
  end

  def mid_x(rect)
    rect[0] + rect[2]/2
  end

  def mid_y(rect)
    rect[1] + rect[3]/2
  end

  def max_x(rect)
    rect[0] + rect[2]
  end

  def max_y(rect)
    rect[1] + rect[3]
  end

  def contains_rect(rect_1,rect_2)
    (rect_1[0]<=rect_2[0] && max_x(rect_1) >= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && max_y(rect_1) >= max_y(rect_2))
  end

  def intersects_x(rect1, rect2)
    (max_x(rect1) > rect2[0] && max_x(rect2) > rect1[0]) || (max_x(rect2) > rect1[0] && max_x(rect1) > rect2[0])
  end

  def intersects_y(rect1, rect2)
    (max_y(rect1) > rect2[1] && max_y(rect2) > rect1[1]) || (max_y(rect2) > rect1[1] && max_y(rect1) > rect2[1])
  end

  def intersects_rect(rect_1, rect_2)
    intersects_x(rect_1, rect_2) && intersects_y(rect_1, rect_2)
  end
  
  def union_rect(rect_1, rect_2)
    x = min_x(rect_1) < min_x(rect_2) ? min_x(rect_1) : min_x(rect_2)
    y = min_y(rect_1) < min_y(rect_2) ? min_y(rect_1) : min_y(rect_2)
    bigger_x = max_x(rect_1) > max_x(rect_2) ? max_x(rect_1) : max_x(rect_2)
    width = bigger_x - x
    bigger_y = max_y(rect_1) > max_y(rect_2) ? max_y(rect_1) : max_y(rect_2)
    height = bigger_y - y
    [x,y,width,height]
  end
  
  def union_rects(rects_array)
    union = rects_array.shift
    rects_array.each do |r|
      union = union_rect(union, r)
    end
    union
  end
  
  def union_graphic_rects(graphics_array)
    rects_array = []
    graphics_array.each do |g|
      rects_array << g.frame_rect
    end
    union_rects(rects_array)
  end
  
  def convert_to_pt(value)
    if value=~/cm$/
      return cm2pt(value.sub("cm","").to_f)
    elsif value=~/mm$/
      return mm2pt(value.sub("mm","").to_f)
    elsif value=~/m$/
      return meter2pt(value.sub("m","").to_f)
    elsif value=~/inch$/
      return inch2pt(value.sub("inch","").to_i)
    end
    value
  end
  
  def pt2mm(pt)
    pt * 0.352778
  end
  
  def pt2cm(pt)
    pt * 0.0352778
  end
  
  def pt2kp(pt)	
    pt * 1.44    
  end
  
  def mm2pt(mm)
    mm * 2.834646
  end
  
  def cm2pt(cm)
    cm * 28.34646
  end
  
  def meter2pt(m)
    m * 2800.34646
  end
  
  def inch2pt(inch)
    inch2pt*72.0
  end
  
  def kp2pt(kp)
    kp / 1.44
  end   


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
  
  def convert_to_nscolor(color)
    return color_from_string(color) if color.class == String
    color
  end
  
  
  def color_from_string(color_string)
    if color_string == nil
      return NSColor.whiteColor
    end

    if color_string==""
      return NSColor.whiteColor
    end

    if COLOR_NAMES.include?(color_string)
      return color_from_name(color_string)
    end
    
    if color_string =~ /^#/
      return color_from_hex(color_string)
    end
    # TODO
    # elsif color_string=~/^#   for hex color
    # RGB=
    ### RGB Colors
    #	"RGB=100,60,0" "RGB=100,60,0"
    # rgb(100,60,0)
    ### CMYK Colors
    #    "CMYK=100,60,0,20" 
    # cmyk(100,60,0,20)
    color_array=color_string.split("=")
    color_kind=color_array[0]
    color_values=color_array[1].split(",")
    if color_kind=~/RGB/
        @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[2].to_f, alpha:color_values[3].to_f)
    elsif color_kind=~/CMYK/
        @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[2].to_f, black:color_values[3].to_f, alpha:color_values[4].to_f)
    elsif color_kind=~/NSCalibratedWhiteColorSpace/
        @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
    elsif color_kind=~/NSCalibratedBlackColorSpace/
        @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)
    else
        @color = color_from_name(color_string)
    end
    @color
  end

  def color_from_name(name)
    case name
    when "black"
      return NSColor.blackColor
    when "blue"
      return NSColor.blueColor
    when "brown"
      return NSColor.brownColor
    when "clear"
      return NSColor.clearColor
    when "cyan"
      return NSColor.cyanColor
    when "dark_gray", "darkGray"
      return NSColor.darkGrayColor
    when "gray"
      return NSColor.grayColor
    when "green"
      return NSColor.greenColor
    when "light_gray", "lightGray"
      return NSColor.lightGrayColor
    when "magenta"
      return NSColor.magentaColor
    when "orange"
      return NSColor.orangeColor
    when "purple"
      return NSColor.purpleColor
    when "red"
      return NSColor.redColor
    when "white"
      return NSColor.whiteColor
    when "yellow"
      return NSColor.yellowColor
    else
      return NSColor.whiteColor
    end
  end
  
  def rgb_color(r,g,b)
    rgba_color(r,g,b,1)
  end

  # @return [UIcolor]
  def rgba_color(r,g,b,a)
    r,g,b = [r,g,b].map { |i| i / 255.0}
    if a > 1.0
      a = a / 255.0
    end
    if RUBY_ENGINE =="rubymotion"
      NSColor.colorWithDeviceRed(r, green: g, blue: b, alpha: a)
    else
      "rgba(#{r},#{g},#{b},#{a})"
    end
  end

  def color_from_hex(color_string)
    puts "color_from_hex of utility"
    hex_color = color_string.gsub("#", "")
    case hex_color.size
      when 3
        colors = hex_color.scan(%r{[0-9A-Fa-f]}).map!{ |el| (el * 2).to_i(16) }
      when 6
        colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
      when 8
        colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map!{ |el| el.to_i(16) }
      else
        raise ArgumentError
    end
    if colors.size == 3
      rgb_color(colors[0], colors[1], colors[2])
    elsif colors.size == 4
      rgba_color(colors[1], colors[2], colors[3], colors[0])
    else
      raise ArgumentError
    end
  end


  def parse_csv(csv_path)
    unless File.exists?(csv_path)
      puts "#{csv_path} doesn't exist ..."
      return nil
    end
    rows=[]
    CSV.foreach(csv_path) do |line|
      rows << line
    end
    rows
  end
  
  
  # divide given array into pieces, tapers the last chunks into even numbers 
  def divide_array_into(array, pieces)
    len = array.length    
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    chunks    
  end

  # it divide an array into chunks of smaller arrays of evenly distrubuted length, the last few arrays might be smaller if it has remainders 
  def chunk_array(array, chunk_length=2)
    pieces=array.length/chunk_length
    if array.length%chunk_length > 0
      pieces +=1
    end
    len = array.length
    mid = (len/pieces)
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    chunks
  end

  # make 1 into 001
  # s= "1", digits = 3
  def make_long_ditit(s, digits)
    s.rjust(digits,"0")
  end

  ############ git related

  # return new or modified file in git repo
  def get_git_modified(path)
    files = `cd #{path} && git status`
    files.split("\n").select do |a|
      if a =~/new file:/ || a =~/modified:/
        true
      end
    end
  end

  STARTING      = "2013-4-20"
  EXPIRATION    = "2013-01-11"
  NETWORK       = "7c:6d:62:8c:dd:aa"
  APP           = "NameCard"
  NAME          = "Min Soo Kim"

  class AboutRLayout
    attr_accessor :name, :app_type, :starting, :expiration
    def initialize
      @name       = NAME
      @app_type   = APP
      @starting   = STARTING
      @expiration = EXPIRATION
      self
    end
    
    def next_step?
      NETWORK
    end
        
    def what_time?
      @expiration
    end
  end
  
end

