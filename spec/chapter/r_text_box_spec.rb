require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'RTextBox creation' do
  before do
    @tb = RTextBox.new(column_count: 2, width:400, height: 700)

  end

  it 'should create RTextBox' do
    @tb.must_be_kind_of RTextBox
  end

  it 'should create two columns' do
    @tb.graphics.length.must_equal 2
  end
end

__END__

describe ' RTextBox creation' do
  before do
    @tb = RTextBox.new(x:50, y:50, :width=>600, :height=>800, :column_count=>4)
    @flowomg_graphics =Graphic.random_graphics(30)
    @svg_path = "/Users/Shared/rlayout/output/text_box_test.svg"

  end

  it 'should create container' do
    @tb.must_be_kind_of RTextBox
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
     @flowing_path = "/Users/Shared/rlayout/output/text_box_flowing_test.svg"
     @tb.save_svg(@flowing_path)
     File.exists?(@flowing_path).must_equal true
  end
end

describe 'test float layout' do
  before do
    @svg_path = "/Users/Shared/rlayout/output/layout_float.svg"
    @tb     = RTextBox.new(column_count: 3, width:500, height:600)
    @image  = Image.new(parent: @tb, is_float: true, fill_color: 'green')
    @image  = Image.new(parent: @tb, is_float: true, fill_color: 'yellow', frame_rect: [3,0,1,10])
    @image  = Image.new(parent: @tb, is_float: true, fill_color: 'blue', frame_rect: [2,0,1,10])
    @tb.layout_floats!
  end

  # it 'should create text_box with floats' do
  #   @tb.graphics.length.must_equal 3
  #   @tb.floats.length.must_equal 2
  # end
  #
  # it 'shoud layout_float' do
  #    @tb.floats.first.puts_frame
  #    @tb.floats.last.puts_frame
  # end
  it 'should save floats' do
    @tb.save_svg(@svg_path)
    File.exists?(@svg_path).must_equal true
  end
end
