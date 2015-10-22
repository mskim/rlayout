require File.dirname(__FILE__) + "/../spec_helper"

describe 'create ImageBox' do
  before do
    @path = "/Users/mskim/mart/group_image"
    @g = ImageBox.new(nil, image_group_path: @path)
  end
  
  it 'should create Image object' do
    assert @g.class == ImageBox
  end
end