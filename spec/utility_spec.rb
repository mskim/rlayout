require File.dirname(__FILE__) + "/spec_helper"

describe 'convert_to_point' do
  before do
    @g= Graphic.new(nil, x: '10cm', y: "2mm", width: '10cm', height: '20cm')
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