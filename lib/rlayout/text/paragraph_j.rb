
# att_string
# kCTVerticalFormsAttributeName
# framesetter 
# kCTFrameProgressionAttributeName
# kCTFrameProgressionRightToLeft
# CTFramesetter
# NSTextLayoutOrientation
# NSTextLayoutOrientationVertical =1
# CTFrameGetFrameAttributes

module RLayout
  class ParagraphJ < Paragraph
    attr_accessor :text_direction, :text_advancement, :vertical_lines
    
    def initialize(parent_graphic, options={})
      super
      @text_font        = 'Hiragino'
      @text_direction   = 'top_to_bottom'
      @text_advancement = 'right_to_left'
      # create_vertical_lines
      self
    end
    
    
    # # TODO use Core Text
    # # This is a hack, but it should work
    # # how about numbers that goes together as horizontal like 11, 120
    # def create_vertical_lines
    #   v_count = @width/@text_size
    #   x = @width - @right_inset
    #   y = @top_inset
    #   width = @text_size
    #   heigth = @height - @top_inset - @bottom_inset
    #   @vertical_lines = []
    #   v_count.times do
    #     @vertical_lines << [x,y,width,height]
    #     x -= @text_size
    #   end
    # end
  end
  
  # class ParagraphView < NSView
  #   def drawRect()
  #     @text_storage=NSTextStorage.alloc.init
  #     @text_storage.setAttributedString @att_string
  #     @layout_manager = NSLayoutManager.alloc.init        
  #     @text_storage.addLayoutManager(@layout_manager)
  #     @text_container = NSTextContainer.alloc.initWithContainerSize(r.size)
  #     @text_container.setLineFragmentPadding(0.0)
  #     @layout_manager.addTextContainer(@text_container)
  #     glyphRange=@layout_manager.glyphRangeForTextContainer(@text_container) 
  #     origin = r.origin
  #     origin.y = origin.y + @data[:text_paragraph_spacing_before] if @data[:text_paragraph_spacing_before]
  #     @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:r.origin)
  #     # create vertical lines
  #     # add vertivals to the layout_manager in right_to_left 
  #     # draw
  #   end
  # end
  
end

