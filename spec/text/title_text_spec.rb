require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TItleText' do
  before do
    @text = "This is a next with return\nand this is second line.\nand this is third line."
    @title = TitleText.new(width: 300, text_string: @text )
    @lines = @title.graphics
  end

  it 'should create TitleText' do
    assert_equal TitleText, @title.class
  end

  it 'should create three lines' do
    assert_equal @lines.length, 2
  end

end
