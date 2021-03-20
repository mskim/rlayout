require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create AdText" do
  before do
    @s = 'this is text.'
    @ad_text      = RLayout::AdText.new(string: @s)
  end

  it 'should create AdText' do
    assert_equal AdText, @ad_text.class 
  end
end


describe "pass AdText with style string" do
  before do
    @s = 'this is text.'
    h = {string: @s, style: "color:red;background-color:black"}
    @ad_text = RLayout::AdText.new(h)
  end

  it 'should create AdText' do
    assert_equal @ad_text.fill[:color], 'black' 
    assert_equal @ad_text.text_record[:color], 'red' 
  end
end