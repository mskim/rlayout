require File.dirname(__FILE__) + "/../spec_helper"

describe 'TextBox creation' do
  before do
    @tb = TextBox.new(nil, column_count: 2, width:400, height: 700)
    puts "text_box"
    puts @tb.puts_frame
    @heading ={}
    @heading[:top_margin] = 0
    @heading[:top_inset]  = 0
    @heading[:left_inset] = 0
    @heading[:right_inset] = 0
    @heading[:layout_expand] = [:width]
    @tb.floats << Heading.new(nil, @heading)
    @tb.relayout!
    @tb.set_non_overlapping_frame_for_chidren_graphics
  end
  it 'should create TextBox' do
    @tb.must_be_kind_of TextBox
  end
  # it 'should have one column' do
  #   @tb.graphics.length.must_equal 2
  # end
end