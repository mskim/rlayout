
if RUBY_ENGINE == "macruby"

require File.dirname(__FILE__) + '/graphic_view_mac/line_drawing'
require File.dirname(__FILE__) + '/graphic_view_mac/fill_drawing'
require File.dirname(__FILE__) + '/graphic_view_mac/image_drawing'
require File.dirname(__FILE__) + '/graphic_view_mac/text_drawing'
require File.dirname(__FILE__) + '/graphic_view_mac/text_drawing'

COLOR_NAMES = %w[black blue brown clear cyan darkGray gray green lightGray magenta orange red white yellow white]

#shape
RECTANGLE   = 0
ROUND_RECT  = 1
CIRCULAR    = 2

class GraphicViewMac < NSView
  attr_accessor :data, :shape
  
  def self.from_data(data)
    x = data.fetch(:x, 0)
    y = data.fetch(:y, 0)
    width = data.fetch(:width, 0)
    height = data.fetch(:height, 0)
    
    frame = NSMakeRect(x, y, width, height)
    view = GraphicViewMac.alloc.initWithFrame(frame)
    view.init_with_data(data)
    view
  end
  
  def init_with_data(data)
    @data = data
    init_fill
    init_line
    init_text
    init_image
    
    # for Containers, add the children graphics
    if @data[:graphics]
      @data[:graphics].each do |child|     
        child_view = GraphicViewMac.from_data(child)
        # child_view = GraphicViewMac.alloc.initWithFrame(NSMakeRect(child[:x], child[:y], child[:width], child[:height]))
        # child_view.init_with_data(child)
        addSubview(child_view)
      end
    end
    
    self
  end
  
  def drawRect(r)
    # @shape = @data.fetch(:shape,0)
    draw_fill(r)
    draw_line(r)
    draw_text(r)
    draw_image(r)
  end
    
  # make it flopped view
  def isFlipped
    true
  end  

  def save_pdf(path, options={})
    pdf_data.writeToFile(path, atomically:false)
    
    if options[:jpg]
      #TODO
      
    end
    
    if options[:thumb]
      #TODO
      
    end
  end

  def pdf_data
      dataWithPDFInsideRect(bounds)
  end

 
  def bezierPathWithRect(r)
    #TODO
        
    case @shape
    when 0   #{}"rectangle", '사각형'
      path = NSBezierPath.bezierPathWithRect(r)
    when 1    #{}"round_corner", '둥근사각형'
      path=NSBezierPath.bezierPath
      if r.size.width > r.size.height
        smaller_side = r.size.height 
      else
        smaller_side = r.size.width 
      end

      if @corner_size == 0 # "small" || @corner_size == '소'
        radious = smaller_side*0.1 
      elsif @corner_size == 1 # "medium" || @corner_size == '중'
        radious = smaller_side*0.2
      elsif @corner_size == 2 #{}"large" || @corner_size == '대'
        radious = smaller_side*0.3
      else
        radious = smaller_side*0.1 
      end
    
      if @inverted_corner
        path = path.appendBezierPathWithRoundedRect(r, xRadius:radious ,yRadius:radious)
      else
        # do inverted corner
        path = path.appendBezierPathWithRoundedRect(r, xRadius:radious ,yRadius:radious)
      end
    when 2 #{}"circle", '원'
      path = NSBezierPath.bezierPathWithOvalInRect(r)
    when 3 #{}"bloon"
      # pointer_direction 0, 45 , 90, 135, 180 ....
      path = NSBezierPath.bezierPathWithOvalInRect(r)
    when 4 #{}"spike"
      # density large, medium, small
      path = NSBezierPath.bezierPathWithOvalInRect(r)
    else
      path = NSBezierPath.bezierPathWithRect(r)
    end
    path
  end
  
  # convert any color to NSColor
  def convert_to_nscolor(color)
    return color_from_string(color) if color.class == String
    color
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
    # TODO
    # elsif color_string=~/^#   for hex color
    
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
        @color = GraphicRecord.color_from_name(color_string)    
    end
    @color
  end

end
else

end