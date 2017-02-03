class Paragraph
  attr_accessor :text_view
    
  def initialize(frame, options={})
    if frame.is_a?(Array)
      frame = NSMakeRect(frame)
    end
    @text_view = NSTextView.alloc.initWithFrame(frame)
    if options[:direction] == 'vertical'
      @text_view.setLayoutOrientation(NSTextLayoutOrientationVertical)
    end
    if options[:text_string]
      @text_view.insertText(options[:text_string])
    end
    self
  end
  
  def save_pdf(path, options={})    
    @text_view.dataWithPDFInsideRect(@text_view.bounds).writeToFile(path, atomically:false)
  end

end
