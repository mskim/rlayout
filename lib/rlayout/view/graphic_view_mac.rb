
#shape
RECTANGLE   = 0
ROUND_RECT  = 1
CIRCULAR    = 2

class GraphicViewMac < NSView
  attr_accessor :graphic
  def self.from_graphic(graphic)
    frame_rect = graphic.frame_rect
    frame = NSMakeRect(frame_rect[0], frame_rect[1], frame_rect[2], frame_rect[3])
    view = GraphicViewMac.alloc.initWithFrame(frame)
    view.init_with_graphic(graphic)
    view
  end

  def init_with_graphic(graphic)
    @graphic = graphic
    @graphic.ns_view = self
    self
  end
  
  def drawRect(r)
    draw_graphic_in_nsview(@graphic, 0)   # draw top level @graphic
  end

  def draw_graphic_in_nsview(graphic, view_depth)
    if view_depth > 0
      @context = NSGraphicsContext.currentContext
      transform = NSAffineTransform.transform            
      @context.saveGraphicsState
      transform.translateXBy(graphic.x, yBy:graphic.y)
      # transform.transformPoint(ns_origin(graphic))
      # transform.transformPoint(ns_origin(graphic))
      # transform.rotateByRadians(0)
      #do rotation       if graphic.rotation?
      transform.concat
    end
    
    draw_fill(graphic)            if graphic.fill
    draw_stroke(graphic)          if graphic.stroke
    draw_text(graphic)            if graphic.text_record
    draw_image(graphic)           if graphic.image_record
    draw_fixtures(graphic.fixtures, view_depth + 1)    if !graphic.fixtures.nil? && graphic.fixtures.length > 0
    draw_graphics(graphic.graphics, view_depth + 1)    if !graphic.graphics.nil? && graphic.graphics.length > 0
    draw_floats(graphic.floats, view_depth + 1)        if !graphic.floats.nil? && graphic.floats.length > 0
    if view_depth > 0
      @context.restoreGraphicsState
    end  
  end
    
  def draw_fixtures(fixtures, view_depth)
      fixtures.each do |child|
        #translate position
        #translate rotation
        draw_graphic_in_nsview(child, view_depth)
      end
      
  end
  
  def draw_graphics(graphics, view_depth)
    graphics.each do |child|
      #translate position
      #translate rotation
      draw_graphic_in_nsview(child, view_depth)
    end
  end
  
  def draw_floats(floats, view_depth)
    floats.each do |child|
      #translate position
      #translate rotation
      draw_graphic_in_nsview(child, view_depth)
    end
  end
  
  def ns_origin(graphic)
    r = graphic.frame_rect
    puts p = NSPoint.new(r[0], r[1])
    p
  end
  
  def ns_bounds_rect(graphic)
    r = graphic.frame_rect
    NSMakeRect(0, 0,r[2],r[3])
  end
  
  def ns_frame_rect(graphic)
    r = graphic.frame_rect
    NSMakeRect(r[0], r[1],r[2],r[3])
  end
    
  # make it flopped view
  def isFlipped
    true
  end

  def save_pdf(path, options={})
    pdf = pdf_data
    pdf.writeToFile(path, atomically:false)
    if options[:jpg]
      image = NSImage.alloc.initWithData pdf
      tiffdata = image.TIFFRepresentation
      jpg_path = path.sub(".pdf", ".jpg")
      tiffdata.writeToFile jpg_path, atomically:false
    end

    if options[:thumb]
      #TODO
    end
  end

  def save_jpg(path)
    image = NSImage.alloc.initWithData pdf_data
    tiffdata = image.TIFFRepresentation
    tiffdata.writeToFile path, atomically:false
  end

  def pdf_data
      dataWithPDFInsideRect(bounds)
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
  

end
