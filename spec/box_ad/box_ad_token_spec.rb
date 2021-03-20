require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create AdToken" do
  before do
    @s = 'this is text.'
    @ad_token      = RLayout::AdToken.new(string: @s)
  end

  it 'should create AdToken' do
    assert_equal AdToken, @ad_token.class 
  end
end


describe "pass AdToken with style string" do
  before do
    @s = 'this is text.'
    h = {string: @s, style: "color:red;background-color:black"}
    @ad_token = RLayout::AdToken.new(h)
  end

  it 'should create AdToken' do
    assert_equal @ad_token.fill[:color], 'black' 
    assert_equal @ad_token.text_record[:color], 'red' 
  end
end