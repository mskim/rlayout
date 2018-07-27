# puts "#{__FILE__}:#{__FILE__}"
# puts "+++++++ #{File.dirname(__FILE__)}"
# puts "#{File.dirname(__FILE__)}" + '/spec_helper'
# require File.dirname(__FILE__) + "/spec_helper"
require_relative "spec_helper"


describe 'convert_to_point' do
  before do
    @g= Graphic.new(x: '10cm', y: "2mm", width: '10cm', height: '20cm')
  end

  it 'should convert unit to point' do
    @g.must_be_kind_of Graphic
  end

  it 'should convert unit to point' do
    @g.x.must_be_kind_of Float
    @g.frame_rect[1].must_be_kind_of Float
    @g.width.must_be_kind_of Float
    @g.height.must_be_kind_of Float
  end
end

describe 'union_rect' do
  before do
    rect_1 = [0,0, 50, 50]
    rect_2 = [100,100, 10, 10]
    @union_rect = union_rect(rect_1, rect_2)
  end

  it 'should have union rect ' do
    assert_equal @union_rect, [0,0,110,110]
  end
end

describe 'should return union_rects' do
  before do
    rects = [[0,0, 50, 50], [100,100, 10, 10], [100,100,100,100], [200,200,100,100]]
    @union_rect = union_rects(rects)
  end

  it 'should return union_rects ' do
    assert_equal @union_rect, [0,0,300,300]
  end
end

describe "should return union_graphic_rects" do
  before do
    graphics = []
    graphics << Graphic.new(x:0,y:0, width:50, height:50)
    graphics << Graphic.new(x:100,y:100, width:10, height:10)
    graphics << Graphic.new(x:100,y:100, width:100, height:100)
    graphics << Graphic.new(x:200,y:200, width:100, height:100)
    @union_rect = union_graphic_rects(graphics)
  end

  it 'should return union_rects ' do
    @union_rect.must_equal [0,0,300,300]
  end
end
