require File.dirname(__FILE__) + "/../spec_helper"

describe 'create page with grid' do
  before do
    @g = Container.new(:show_grid=>true, :grid_base => [7,12], :gutter=>5, :width=>400, :height=>600, :left_margin=>50, :top_margin=>50, :right_margin=>50, :bottom_margin=>50)
    @path = "/Users/Shared/rlayout/output/grid_test.pdf"
  end
  
  it 'should create Image object' do
    @g.must_be_kind_of Graphic
  end
  
  it 'shuld have attribute of image_path' do
    @g.grid_cells.length.must_equal 84
  end
  
  it 'should draw image' do
    @g.save_pdf(@path)
    File.exists?(@path).must_equal true
    system("open #{@path}")
  end
  
end