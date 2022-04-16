require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe ' NewsPillar creation' do
  before do
    @pillar_path   =  "/Users/mskim/test_data/2021-01-29/2/2"
    @height_in_lines = 102
    h = {}
    h[:pillar_path]     = @pillar_path
    h[:relayout]        = true
    h[:height_in_lines] = @height_in_lines
    @pillar             = NewsPillar.new(h)
  end

  it 'should create NewsPillar' do
    assert_equal NewsPillar, @pillar.class
    assert_equal @height_in_lines, @pillar.height_in_lines_sum
  end

  # it 'should auto_adjust_height' do
  #   @pillar.auto_adjust_height_all
  #   assert_equal @pillar.height_in_lines, @pillar.height_in_lines_sum
  # end
end

describe 'NewsPillar w' do
  before do
    @pillar_path        =  "/Users/mskim/test_data/2017-05-30/17/1"
    @pillar             = NewsPillar.new(pillar_path: @pillar_path, adjustable_height: true)
    h[:pillar_path]     = @pillar_path
    h[:relayout]        = true
    @pillar             = NewsPillar.new(h)
  end

  it 'should create NewsPillar' do
    assert_equal NewsPillar, @pillar.class
    assert_equal @height_in_lines, @pillar.height_in_lines_sum
  end

end

