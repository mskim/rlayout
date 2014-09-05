require File.dirname(__FILE__) + "/spec_helper"

describe 'testing container creation' do
  before do
    @container = Container.new(nil)
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
  end
  
  it 'should have default values' do
    @container.x.must_equal 0
    @container.y.must_equal 0
    @container.width.must_equal 100
    @container.height.must_equal 100
  end
end

describe 'testing container with graphics' do
  before do
    @container = Container.new(nil)
    @g1 = Graphic.new(@container)
    @g2 = Graphic.new(@container)
  end
  
  it 'should add graphics' do
    @container.graphics.length.must_equal 2
    @container.graphics.length.must_equal 2
  end
  
  it 'added graphics should have self as parent' do
    @container.graphics[0].parent_graphic.must_equal @container
    @container.graphics[1].parent_graphic.must_equal @container
  end
end