require File.dirname(__FILE__) + "/spec_helper"

describe 'testing container creation' do
  before do
    @container = Container.new(nil, :width=>600, :height=>800, :layout_space=>20) do
      rect(:fill_color=>"red", :unit_length=>3)
      rect(:fill_color=>"blue")
      circle(:fill_color=>"green")
      relayout!
    end
    puts @container.graphics.length
    @path = File.dirname(__FILE__) + "/output/container_test.svg"
    
  end
  
  it 'should create container' do
    @container.must_be_kind_of Container
    @container.graphics.length.must_equal 3
    @container.graphics[0].must_be_kind_of Rectangle
    # @container.graphics[0].puts_frame
    # @container.graphics[1].puts_frame
    # @container.graphics[2].puts_frame
  end
  
  it 'should save' do
    @container.save_svg(@path)
    File.exists?(@path).must_equal true
    # system("open #{@path}") if File.exists?(@path)
    
  end
end
