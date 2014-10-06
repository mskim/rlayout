require File.dirname(__FILE__) + "/spec_helper"

describe ' ObjectBox creation' do
  before do
    @ob = ObjectBox.new(nil, x:50, y:50, :width=>600, :height=>800, :column_count=>4)
    @flowomg_graphics =Graphic.random_graphics(30)
    @svg_path = File.dirname(__FILE__) + "/output/object_box_test.svg"
  end
  
  it 'should create container' do
    @ob.must_be_kind_of ObjectBox
    @ob.graphics.length.must_equal 4
    @ob.graphics[0].must_be_kind_of ColumnObject
    @ob.graphics[0].x.must_equal 0
  end
  
  it 'should save' do
    @ob.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    # system("open #{@svg_path}") if File.exists?(@svg_path)
  end
  
  it 'should layout_items' do
     result = @ob.layout_items(@flowomg_graphics)
     @flowing_path = File.dirname(__FILE__) + "/output/object_box_flowing_test.svg"
     @ob.save_svg(@flowing_path)
     File.exists?(@flowing_path).must_equal true
  end
   
  # it 'should save pdf' do
  #   puts result = @ob.layout_items(@flowomg_graphics, 0)
  #   @flowing_path = File.dirname(__FILE__) + "/output/object_box_flowingtest.pdf"
  #   @ob.save_pdf(@flowing_path)
  #   File.exists?(@flowing_path).must_equal true
  # end
end
