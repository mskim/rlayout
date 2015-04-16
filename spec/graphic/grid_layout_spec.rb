require File.dirname(__FILE__) + "/../spec_helper"

describe 'create GridLayout' do
  before do
    @g = RLayout::GridLayout.new("7x11/5", :frames=>[[0,0,1,1], [1,0,1,1]])
  end
  
  it 'should create GridLayout' do
    @g.must_be_kind_of RLayout::GridLayout
  end
  
  it 'should create @frames' do
    @g.frames.first.must_be_kind_of RLayout::Frame
    @g.frames.length.must_equal 2
  end
  
  it 'should flip horizontally' do
    @g.flip_horizontally
    @g.frames.first.frame.must_equal [6,0,1,1]
  end
  
  it 'should flip vertically' do
    @g.flip_vertically
    @g.frames.first.frame.must_equal [0,10,1,1]
  end
  

end

describe 'should detect for equl frames content' do
  it 'should detect for equal frames' do
    first = [[6,0,1,1],[0,10,1,1], [1,1,1,1]]
    second = [[1,1,1,1], [0,10,1,1], [6,0,1,1]]
    result = RLayout::GridLayout.has_equal_frames?(first, second)
    result.must_equal true
  end
  
end

describe 'should detect for has_heading? frames content' do
  before do
    @g = RLayout::GridLayout.new("7x11/H/5", :frames=>[[0,0,1,1], [1,0,1,1]])
  end
  it 'should detect has_heading?' do
    @g.has_heading?.must_equal true
  end
end