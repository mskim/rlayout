framework 'cocoa'
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

require 'minitest/autorun'
describe 'create ParagraphView' do
  before do
    f = NSMakeRect(0,0,200,200)
    str = "しかし、これは非常に複雑で、広範囲であるために一般的に使用するには無理が伴います。SGMLの規則によりながら、Webに使用するいくつかのマークアップのみを定義して使用したものがHTMLです。
    "
    
    options = {direction: 'vertical', text_string: str}
    @p = Paragraph.new(f, options)
    @pdf_path = File.dirname(__FILE__) + "/text_view_test.pdf"
  end
  
  it 'should create Paragraph' do
    @p.must_be_kind_of Paragraph
  end
  
  it 'should create NSTextView' do
    @p.text_view.must_be_kind_of NSTextView
  end
  
  it 'should set text direction' do
    @p.text_view.layoutOrientation.must_equal NSTextLayoutOrientationVertical
  end
  
  it 'should save view' do
    @p.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end