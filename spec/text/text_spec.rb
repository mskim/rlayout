require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'text_drawing test' do
  before do
    @text = Text.new(:text_string=> "This is text string.")
    @path = "/Users/Shared/rlayout/output/text_drawing_test.svg"
  end

  it 'should create Text object' do
    @text.must_be_kind_of Text
  end
end

describe 'text_drawing test' do
  before do
    @text = Text.new(:text_string=> "This is text string.", x: 0, y:5, font: 'KoPubDotumPB', font_size: 12, width: 170, left_margin: 0, left_inset: 0)
  end

  it 'should create Text object' do
    @text.must_be_kind_of Text
  end
end
