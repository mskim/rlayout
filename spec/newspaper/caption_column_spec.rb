require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create caption column' do
  before do
    @cc                     = CaptionColumn.new(width: 500, height: 500)
    @graphics               = @cc.graphics
  end

  it 'should create CaptionColumn' do
    assert_equal CaptionColumn, @cc.class
    assert_equal 1, @cc.bottom_space_in_lines
    assert_equal 15, @cc.body_line_height
    assert_equal 10, @cc.caption_line_height
  end

  it 'should create one line' do
    assert_equal 1, @graphics.length
  end
end
