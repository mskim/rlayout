require File.dirname(__FILE__) + "/spec_helper"

describe 'testing container creation' do
  before do
    @con = Container.new(nil, :layout_mode=>"grid", :width=>600, :height=>800, :layout_space=>20) do
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      circle(:fill_color=>"green")
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      relayout_grid!
    end
    @path = File.dirname(__FILE__) + "/output/container_grid_test.svg"
    
  end
  
  it 'should create container' do
    @con.must_be_kind_of Container
    @con.graphics.length.must_equal 9
    @con.graphics[0].must_be_kind_of Rectangle
    @con.graphics[0].x.must_equal 0
    @con.graphics.first.width.must_equal 100
    # @con.graphics[0].puts_frame
    # @con.graphics[1].puts_frame
    # @con.graphics[2].puts_frame
  end
  
  it 'should save' do
    @con.save_svg(@path)
    File.exists?(@path).must_equal true
    # system("open #{@path}") if File.exists?(@path)
    
  end
end
