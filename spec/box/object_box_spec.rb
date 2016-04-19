
require File.dirname(__FILE__) + "/../spec_helper"

describe 'create ObjectBox' do
  before do
    @path = "/Users/mskim/mart/group_image"
    @g = ObjectBox.new(width: 400, height: 600,)
  end
  
  it 'should create ObjectBox' do
    assert @g.class == ObjectBox
  end
  
  # it 'should layout_image!' do
  #   @g.layout_images!
  #   assert @g.graphics.first.class == Image
  # end
end