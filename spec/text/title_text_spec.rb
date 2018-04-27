require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create TItleText' do
  before do
    @text = "This is a next with return\nand this is second line."
    @title = TitleText.new(width: 300, text_string: @text )
  end

  it 'should create TitleText' do
    assert_equal TitleText, @title.class
  end

end
