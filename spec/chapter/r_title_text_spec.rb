require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create RTileText' do
  before do
    @text = "This is a next with return\nand this is second line."
    @title = RTitleText.new(width: 300, text_string: @text )
  end

  it 'should create RTitleText' do
    @title.must_be_kind_of RTitleText
  end

end
