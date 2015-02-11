
if RUBY_ENGINE == "macruby"
framework 'cocoa'
COLOR_NAMES = %w[black blue brown clear cyan darkGray gray green lightGray magenta orange red white yellow white]

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
    if @graphic.fixtures
      @graphic.fixtures.each do |child|     
        child_view = GraphicViewMac.from_graphic(child)        
        addSubview(child_view)
      end
    end

    # for Containers, add the children graphics
    if @graphic.graphics
      @graphic.graphics.each do |child| 
        child_view = GraphicViewMac.from_graphic(child)
        addSubview(child_view)
      end
    end
    
    if @graphic.floats 
      @graphic.floats.each do |child|    
        child_view = GraphicViewMac.from_graphic(child)
        addSubview(child_view)
      end
    end
    self
  end
  
  def drawRect(r)
    @graphic.draw_fill(r)
    @graphic.draw_image(r)
    @graphic.text_layout_manager.draw_text(r)  if @graphic.text_layout_manager
    @graphic.draw_line(r)
    @graphic.draw_shade(r)    if @graphic.respond_to?(:draw_shade)
    @graphic.draw_grid(r)     if @graphic.respond_to?(:grid_base) && @graphic.show_grid
    @graphic.draw_grid_rects  if @graphic.respond_to?(:grid_rects) && @graphic.grid_rects
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

end
end
