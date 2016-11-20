require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
include RLayout

describe 'graphic_drawing test' do
  before do
    @g = Graphic.new(stroke_width: 1, x: 200, y:200, fill_color: 'red')
    @path = "/Users/Shared/rlayout/output/stoke_drawing_test.svg"
  end
  
  it 'should create Graphic object' do
    @g.must_be_kind_of Graphic
  end
  
  it 'should draw image' do
    @g.save_svg(@path)
    File.exist?(@path).must_equal true
    system("open #{@path}")
  end  
end
