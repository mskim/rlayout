require File.dirname(__FILE__) + "/spec_helper"

describe 'TextBox creation' do
  before do
    @tb = TextBox.new(nil, column_count: 2, width:400, height: 700)
    @heading ={}
    @heading[:top_margin] = 0
    @heading[:top_inset]  = 0
    @heading[:left_inset] = 0
    @heading[:right_inset] = 0
    @heading[:layout_expand] = [:width]
    @tb.floats << Heading.new(nil, @heading)
    @tb.relayout!
    @tb.set_overlapping_grid_rect
  end
  
  it 'should create TextBox' do
    @tb.must_be_kind_of TextBox
  end
  
  it 'should return width_of_columns' do
    @tb.width_of_columns(0).must_equal 0
    @tb.width_of_columns(1).must_equal 195
    @tb.width_of_columns(2).must_equal 400
  end
end

__END__
describe ' TextBox creation' do
  before do
    @tb = TextBox.new(nil, x:50, y:50, :width=>600, :height=>800, :column_count=>4)
    @flowomg_graphics =Graphic.random_graphics(30)
    @svg_path = File.dirname(__FILE__) + "/output/text_box_test.svg"
  end
  
  it 'should create container' do
    @tb.must_be_kind_of TextBox
    @tb.graphics.length.must_equal 4
    @tb.graphics[0].must_be_kind_of TextColumn
    @tb.graphics[0].x.must_equal 0
  end
  
  it 'should save' do
    @tb.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
    # system("open #{@svg_path}") if File.exists?(@svg_path)
  end
  
  it 'should layout_items' do
     result = @tb.layout_items(@flowomg_graphics)
     @flowing_path = File.dirname(__FILE__) + "/output/text_box_flowing_test.svg"
     @tb.save_svg(@flowing_path)
     File.exists?(@flowing_path).must_equal true
  end
end
