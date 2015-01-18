require File.dirname(__FILE__) + "/../spec_helper"

describe 'test float layout' do
  before do
    @pdf_path = File.dirname(__FILE__) + "/../output/layout_float.pdf"
    @tb     = TextBox.new(nil, column_count: 3, width:500, height:600)
    @image  = Image.new(@tb, is_float: true, fill_color: 'green')
    @image  = Image.new(@tb, is_float: true, fill_color: 'yellow', frame_rect: [3,0,1,10])
    @image  = Image.new(@tb, is_float: true, fill_color: 'blue', frame_rect: [2,0,1,10])
    @tb.layout_floats!
  end
  
  # it 'should create text_box with floats' do
  #   @tb.graphics.length.must_equal 3
  #   @tb.floats.length.must_equal 2
  # end
  # 
  # it 'shoud layout_float' do
  #    @tb.floats.first.puts_frame
  #    @tb.floats.last.puts_frame
  # end
  it 'should save floats' do
    @tb.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
    
  end
end