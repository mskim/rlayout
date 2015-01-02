require File.dirname(__FILE__) + "/../spec_helper"

describe 'adjust frame with grid_frame' do
  before do
    @p = Page.new(nil, grid: [3,3], :gutter=>10, :v_gutter=>5)
    Graphic.new(@p, :grid_frame=>[0,0,3,1], :fill_color=>'green')
    Graphic.new(@p, :grid_frame=>[1,1,1,1], :fill_color=>'red')
    Graphic.new(@p, :grid_frame=>[2,2,1,1], :fill_color=>'blue')
    @pdf_path = File.dirname(__FILE__) + "/../output/grid_frame_test.pdf"
  end
  
  it 'should create grid_cells in page' do
    @p.grid_cells.length.must_equal 9
  end
  it 'should create gutter in page' do
    @p.gutter.must_equal 10
  end
  
  it 'should save' do
    @p.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
end