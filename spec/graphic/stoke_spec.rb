require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'graphic_drawing test' do
  before do
    # @g = Graphic.new(stroke_width: 1, x: 200, y:200, fill_color: 'red', stoke_color:'green')
    @g = Graphic.new(stroke_width: 1, fill_color: 'yellow', stroke_color:'red')
    @pdf_path = "/Users/mskim/test_data/graphic/stoke_test.pdf"
    @svg_path = "/Users/mskim/test_data/graphic/stoke_test.svg"
  end
  
  it 'should create Graphic object' do
    assert_equal Graphic, @g.class 
  end
  
  it 'should save pdf' do
    @g.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end  
  
  it 'should save svg' do
    @g.save_svg(@svg_path)
    assert File.exist?(@svg_path)
    system("open #{@svg_path}")
  end  
end
