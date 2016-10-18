require 'minitest/autorun'
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '../..', 'lib')
require 'rlayout/graphic'
require 'rlayout/container'
include RLayout

describe 'create Container with grid' do
  before do
    @g = Container.new(:show_grid=>true, :grid_base => [7,12], :gutter=>5, :width=>400, :height=>600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50)
    @path = "/Users/Shared/rlayout/output/grid_test.svg"
  end
  
  it 'should create Container' do
    @g.must_be_kind_of Container
  end
  
  it 'shuld have attribute of image_path' do
    @g.grid_cells.length.must_equal 84
  end
  
  it 'should draw image' do
    @g.save_svg(@path)
    File.exists?(@path).must_equal true
    # system("open #{@path}")
  end
  
end