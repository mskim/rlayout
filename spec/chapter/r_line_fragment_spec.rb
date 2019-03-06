require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe "create LineFragment" do
  before do
    options = {x: 0, y: 0, width: 300, height: 16}
    @line = RLineFragment.new(options)
  end

  it 'should create line' do
    @line.must_be_kind_of RLineFragment
  end

  it 'should return all covered un_covered_rec' do
    rect = @line.un_covered_rect(@line.frame_rect, [0, 0, 400, 16])
    rect[0].must_equal 0
    rect[2].must_equal 0
  end
  it 'should return right covered un_covered_rec' do
    rect = @line.un_covered_rect(@line.frame_rect, [150, 0, 400, 16])
    rect[0].must_equal 0
    rect[2].must_equal 150
  end

  it 'should return left covered un_covered_rect' do
    rect = @line.un_covered_rect(@line.frame_rect, [0, 0, 150, 16])
    rect[0].must_equal 150
    rect[2].must_equal 150
  end

end
