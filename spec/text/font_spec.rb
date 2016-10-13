require File.dirname(__FILE__) + "/../spec_helper"

describe 'create RFont' do
  before do
    @f = RFont.new("Times", 16)
    @string = "This is good."
    @s_size = RFont.string_size(@string, "some_font", 16)
  end
  
  it 'should create RFont' do
    assert @f.class == RFont
  end
    
  it 'should return string width' do    @s_size[0].class == Fixnum
    @s_size[1].class == Fixnum
  end
end