require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe "create LineFragment" do
  before do
    options = {x: 0, y: 0, width: 300, height: 16}
    @line_f = LineFragment.new(options)
  end

  it 'should create line' do
    assert_equal  @line_f.class , LineFragment
    assert_equal @line_f.x, 0
    assert_equal @line_f.y, 0
    assert_equal @line_f.width, 300
    assert_equal @line_f.height, 16
  end

end
