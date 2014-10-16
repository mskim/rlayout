
# kCTVerticalFormsAttributeName
# CTFramesetter
# NSTextLayoutOrientation
# NSTextLayoutOrientationVertical =1
# CTFrameGetFrameAttributes

module RLayout
  class ParagraphJapanese < Paragraph
    attr_accessor :text_direction, :text_advancement
    
    def initialize(parent_graphic, options={})
      super
      @text_font        = 'Hiragino'
      @text_direction   = 'vertical'
      @text_advancement = 'right_to_left'
      
      self
    end
  end
  
end

