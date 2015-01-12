require File.dirname(__FILE__) + "/spec_helper"

describe 'TextColumn creation' do
  before do
    @tb = TextBox.new(nil, column_count: 2, width:400, height: 700, body_line_height: 18)
    @tc = @tb.graphics.first
    @tc.create_grid_rects
  end
  
  it 'should create TextColumn' do
    @tc.must_be_kind_of TextColumn
  end
  
  it 'should create grid_rects' do
    @tc.grid_rects.must_be_kind_of Array
    @tc.grid_rects.length.must_equal 87
  end
  
  it 'shoul test simple_rect?' do
    @tc.grid_rects.first.overlap?.must_equal false
  end
  
  it 'should get the line at position' do
    grid_line = @tc.current_grid_rect_at_position(20)
    grid_line.must_be_kind_of GridRect
    # puts "grid_line.rect:#{grid_line.rect}"
  end
end

# describe 'path addition' do
#   before  do
#     @tb = TextBox.new(nil, column_count: 2, width:400, height: 700, body_line_height: 18)
#     @tc = @tb.graphics.first
#     @tc.create_grid_rects
#     @proposed_path   = CGPathCreateMutable()
#     bounds          = CGRectMake(10, 10, 100, 100)
#     CGPathAddRect(@proposed_path, nil, bounds)
#     @proposed_path.stroke
#   end
#   
#   it 'should draw path' do
#     
#   end
# 
# end
__END__
describe 'TextColumn creation test' do
  before do
    @tb       = TextColumn.new(nil, :width=>300, :height=>800)
    @path     = File.dirname(__FILE__) + "/../output/text_column_test.svg"
    @pdf_path = File.dirname(__FILE__) + "/../output/text_column_test.pdf"
    # puts @para.inspect
  end
  
  it 'should create TextColumn object' do
    @tb.must_be_kind_of TextColumn
    @tb.line_grid_height.must_equal 30
    @tb.line_grid_offset.must_equal 0
    @tb.line_grid_count.must_equal 26
    @tb.line_grid_rects.must_be_kind_of Array
  end
  
  it 'should insert paragraphs' do
    @para_list = Paragraph.generate(5)
    @para_list.must_be_kind_of Array
    @para_list.first.must_be_kind_of Paragraph
    @para_list.each do |item|
      item.change_width_and_adjust_height(@tb.width)
      @tb.insert_item(item)
    end
    # @tb.relayout!

    # @tb.save_svg(@path)
    @tb.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
end

