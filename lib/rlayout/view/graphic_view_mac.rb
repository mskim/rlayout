
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
    frame = NSMakeRect(graphic.text_rect[X_POS], graphic.text_rect[Y_POS], graphic.text_rect[WIDTH_VAL], graphic.text_rect[HEIGHT_VAL])
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
    @graphic.draw_grid(r)  if @graphic.grid && @graphic.show_grid
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

end
end
