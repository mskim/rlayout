require File.dirname(__FILE__) + "/../spec_helper"

describe 'testing Head creation' do
  before do
    text_options = {text_string: "Some Head Text Here!", text_size: 16, text_color: "brown", x:10, y: 10, width: 400, height: 80}
    options = { width: 500, height: 100, text_options: text_options}
    @head = Head.new(options)
  end
  
  it 'should create Heading' do
    assert @head.class == Head
  end

  it 'should create text_object' do
    assert @head.text_object.class == Text
  end
  
  it 'should have frame_rect' do
    assert @head.text_object.frame_rect == [10,10,400,80]
  end

end
