require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Grid' do
  before do
    @g = Grid.new( :grid_base => [7,12], :gutter=>5, :width=>400, :height=>600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50)
    @path = "/Users/Shared/rlayout/output/grid_test.svg"
  end

  it 'should create Grid' do
    assert_equal Grid, @g.class
    assert_equal 0, @g.left_margin
    assert_equal 0, @g.top_margin
  end

  it 'shuld create grid_cells' do
    assert_equal 84, @g.grid_cells.length
    assert_equal 0, @g.grid_cells.first[:x]
    assert_equal 0, @g.grid_cells.first[:y]
    
  end

  it 'should draw image' do
    @g.save_svg(@path)
    assert File.exist?(@path)
    # system("open #{@path}")
  end

end
