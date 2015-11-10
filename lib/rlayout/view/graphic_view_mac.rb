=begin
- (id)shadeColor:(NSColor *)color shade:(float)s {
    NSString *space = [color colorSpaceName];
    if(s == 1) return color;
    if([space isEqualToString:SMDeviceSpotColorSpace]) {
  float c, m, y, k;
  NSString *colorName;
  NSColor *screenColor = [(SMSpotColor *)color screenColor];
  [screenColor getCyan:&c magenta:&m yellow:&y black:&k alpha:NULL];
  colorName = [color colorNameComponent];
  color = [SMSpotColor colorWithSpotCyan:c magenta:m yellow:y black:k alpha:1.0 name:colorName];
  [(SMSpotColor *)color setShade:s];
  return color;
    }
    else if(tocmyk || [space isEqualToString:NSDeviceCMYKColorSpace]) {
  float c, m, y, k, a;
  [[color colorUsingColorSpaceName:NSDeviceCMYKColorSpace] getCyan:&c magenta:&m yellow:&y black:&k alpha:&a];
  return [NSColor colorWithDeviceCyan:c*s magenta:m*s yellow:y*s black:k*s alpha:a];
    } else if([space isEqualToString:NSCalibratedWhiteColorSpace] || [space isEqualToString:NSDeviceWhiteColorSpace]) {
  float w = (1.0 - [color whiteComponent]) * s;
  return [NSColor colorWithCalibratedWhite:w alpha:[color alphaComponent]];
    } else {
  float r, g, b, a;
  s = 1.0 - s;
  [color getRed:&r green:&g blue:&b alpha:&a];
  return [NSColor colorWithCalibratedRed:r + (1.0 - r)*s green:g + (1.0-g)*s blue:b+(1.0 - b)*s alpha:a];
    }
}
=end

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
    draw_graphic_in_nsview(@graphic)
  end

  def draw_graphic_in_nsview(graphic)
    @context = NSGraphicsContext.currentContext
    transform = NSAffineTransform.transform            
    @context.saveGraphicsState
    transform.translateXBy(graphic.x, yBy:graphic.y)
    
    if graphic.rotation
      transform.transformPoint(ns_center_point(graphic))
      # transform.rotateByRadians(-graphic.rotation)
      # using -angle for flipped view
      transform.rotateByDegrees(-graphic.rotation)
    end
    transform.concat
    draw_shadow(graphic)          if graphic.shadow
    draw_fill(graphic)            if graphic.fill
    draw_grid_rects(graphic)      if graphic.class == RLayout::TextColumn
    draw_text(graphic)            if graphic.text_record || graphic.text_layout_manager
    draw_image(graphic)           if graphic.image_record
    draw_stroke(graphic)          if graphic.stroke
    draw_fixtures(graphic.fixtures)    if !graphic.fixtures.nil? && graphic.fixtures.length > 0
    draw_graphics(graphic.graphics)    if !graphic.graphics.nil? && graphic.graphics.length > 0
    draw_floats(graphic.floats)        if !graphic.floats.nil? && graphic.floats.length > 0
    @context.restoreGraphicsState
  end
    
  def draw_fixtures(fixtures)
      fixtures.each do |child|
        draw_graphic_in_nsview(child)
      end
  end
  
  def draw_graphics(graphics)
    graphics.each do |child|
      draw_graphic_in_nsview(child)
    end
  end
  
  def draw_floats(floats)
    floats.each do |child|
      draw_graphic_in_nsview(child)
    end
  end
  
  def draw_grid_rects(graphic)
    return if graphic.show_grid_rects == false
    NSColor.yellowColor.set
    if  graphic.grid_rects && graphic.grid_rects.length > 0
      graphic.grid_rects.each {|line| line.draw_grid_rect}
    end
  end
    
  def ns_origin(graphic)
    r = graphic.frame_rect
    puts p = NSPoint.new(r[0], r[1])
    p
  end
  
  def ns_center_point(graphic)
    r = graphic.frame_rect
    x_center = r[0] + r[2]/2.0
    y_center = r[1] + r[3]/2.0
    NSPoint.new(x_center, y_center)
  end
  
  def ns_bounds_rect(graphic)
    r = graphic.frame_rect
    NSMakeRect(0, 0,r[2],r[3])
  end
  
  def ns_frame_rect(graphic)
    r = graphic.frame_rect
    NSMakeRect(r[0],r[1],r[2],r[3])
  end
    
  def isFlipped
    true
  end

  def save_pdf(pdf_path, options={})
    pdf = pdf_data
    unless options[:pdf] == false
      pdf.writeToFile(pdf_path, atomically:false) 
    end 
      
    if options[:jpg]
      compression = options[:compression] || 0.5
      compression = compression.to_f
      image       = NSImage.alloc.initWithData pdf
      imageData   = image.TIFFRepresentation
      imageRep    = NSBitmapImageRep.imageRepWithData(imageData)  
      # imageProps  = {NSImageCompressionFactor=> 1.0}
      imageProps  = NSDictionary.dictionaryWithObject(NSNumber.numberWithFloat(compression), forKey:NSImageCompressionFactor)
      imageData   = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
      jpg_path    = pdf_path.sub(".pdf", ".jpg")
      # puts "imageData.class:#{imageData}.class"
      imageData.writeToFile(jpg_path, atomically:false)      
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
    elsif color_string=~/^#/   #for hex color
      string = color_string[1..5] 
      color_values = hex2rgb(string)
      return NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[2].to_f, alpha:1.0)
    end
    color_array=color_string.split("=")
    color_kind=color_array[0]
    color_values=color_array[1].split(",")
    case color_kind
    when "RGB" , "rgb"  
        @color = NSColor.colorWithCalibratedRed(color_values[0].to_f, green:color_values[1].to_f, blue:color_values[2].to_f, alpha:color_values[3].to_f)
    when "CMYK", "cmyk"
        @color = NSColor.colorWithDeviceCyan(color_values[0].to_f, magenta:color_values[1].to_f, yellow:color_values[2].to_f, black:color_values[3].to_f, alpha:color_values[4].to_f)
    when "NSCalibratedWhiteColorSpace"
        @color = NSColor.colorWithCalibratedWhite(color_values[0].to_f, alpha:color_values[1].to_f)
    when "NSCalibratedBlackColorSpace"
        @color = NSColor.colorWithCalibratedBlack(color_values[0].to_f, alpha:color_values[1].to_f)
    else
        @color = NSColor.whiteColor
    end
    @color
  end

  def hex2rgb(hex)
    d_hex = hex.downcase
    r,g,b = d_hex[0..1], d_hex[2..3], d_hex[4..5]
    [r,g,b].map { |e| e.to_i(16) }
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
  
  def self.pdf2jpg(pdf_path, options={})
    url = NSURL.fileURLWithPath pdf_path
    pdfdoc = PDFDocument.alloc.initWithURL url
    compression = options[:compression] || 0.5
    compression = compression.to_f
    page_count = pdfdoc.pageCount
    page_count.times do |i|
      page = pdfdoc.pageAtIndex i
      pdfdata = page.dataRepresentation
      image = NSImage.alloc.initWithData pdfdata
      outfile = pdf_path.sub(".pdf", ".jpg")
      if page_count > 1
        outfile = "#{pdf_path}_#{i+1}.jpg"
      end
      imageData = image.TIFFRepresentation
      imageRep = NSBitmapImageRep.imageRepWithData(imageData)  
      imageProps = NSDictionary.dictionaryWithObject(NSNumber.numberWithFloat(compression), forKey:NSImageCompressionFactor)
      imageData = imageRep.representationUsingType(NSJPEGFileType, properties:imageProps)
      imageData.writeToFile(outfile, atomically:false)
    end
    
  end

end
