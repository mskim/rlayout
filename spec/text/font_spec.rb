require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create RFont' do
  before do
    @f = RFont.new("Times", 16)
    @string = "This is good."
    @s_size = RFont.string_size(@string, "some_font", 16.0)
  end

  it 'should create RFont' do
    assert @f.class == RFont
  end

  it 'should return string width' do    @s_size[0].class == Integer
    @s_size[1].class == Integer
  end
end

describe 'check width of KoPubBatangPB 1번 ' do
  before do
    @f = RFont.new("KoPubBatangPB", 42.0)
    @string = "1번"
    @s_size = RFont.string_size(@string, "KoPubBatangPB", 16.0)
    @string2 = "일번"
    @s_size2 = RFont.string_size(@string2, "KoPubBatangPB", 16.0)
  end

  it 'should create RFont' do
    assert @f.class == RFont
  end

  it 'should return string width' do   
    assert_equal @s_size[0], 15.122688
  end

  it 'should return string width2' do   
    assert_equal @s_size2[0], 29.952
  end
end

