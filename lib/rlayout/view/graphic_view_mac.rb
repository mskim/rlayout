
if RUBY_ENGINE == "macruby"
framework 'cocoa'
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
  attr_accessor :graphic
  
  def self.from_graphic(graphic)      
    frame = NSMakeRect(graphic.text_rect[0], graphic.text_rect[1], graphic.text_rect[2], graphic.text_rect[3])
    view = GraphicViewMac.alloc.initWithFrame(frame)
    view.init_with_graphic(graphic)
    view
  end
  
  def init_with_graphic(graphic)
    @graphic = graphic  
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
    @graphic.draw_line(r)
    @graphic.draw_image(r)
    @graphic.text_layout_manager.draw_text(r)  if @graphic.text_layout_manager
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
