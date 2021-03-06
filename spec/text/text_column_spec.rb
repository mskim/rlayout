require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'TextBox test' do
  before do
template =<<EOF
# heading is inside of main_text as float.
# heading column is set to 2.
RLayout::Document.new(:initial_page=>false) do
  page do
    main_text(heading_columns: 3, column_count: 3, grid_base: "3x4") do
      heading(fill_color: "CMYK=0.1,0,0,0.5,1")
      float_image(:local_image=> "1.jpg", :grid_frame=> [0,0,1,1])
      float_image(:local_image=> "2.jpg", :grid_frame=> [0,1,1,1])
    end
  end

  page do
    main_text(column_count: 3) do
      float_image(:local_image=> "3.jpg", :grid_frame=> [1,0,2,2])
    end
  end
end


EOF
    @doc          = eval(template)
    @text_box     = @doc.pages.first.main_box
    @heading      = @text_box.floats.first
    @text_box.set_overlapping_grid_rect
    @text_box.update_column_areas
    @first_column = @doc.pages.first.main_box.graphics.first
    @second_column= @doc.pages.first.main_box.graphics[1]
    @third_column = @doc.pages.first.main_box.graphics[2]
    puts "@third_column.current_position:#{@second_column.current_position}"
    puts  "@third_column.is_simple_column?:#{@third_column.is_simple_column?}"
    puts  "@third_column.is_rest_of_area_simple?:#{@third_column.is_rest_of_area_simple?}"
    puts  "@third_column.is_simple_column?:#{@third_column.is_simple_column?}"

  end
  # it 'shold create Document' do
  #   @doc.class.must_equal Document
  # end
  #
  # it 'shold create TextBox' do
  #   @text_box.class.must_equal TextBox
  # end
  it 'shold create TextColumn' do
    @second_column.class.must_equal TextColumn
  end

end

__END__
describe 'TextBox test' do
  before do
    @tb = TextBox.new(column_count: 2, width: 400, height:500)
    @tb.floats << Image.new(parent: @tb, x:150, width:150, is_float: true)
    @tb.floats << Image.new(parent: @tb, x:0, y:300, width:300, is_float: true)
    @tb.create_column_grid_rects
    @tb.set_overlapping_grid_rect
    @column = @tb.graphics.first
    @column2 = @tb.graphics[1]
  end

  it 'should create path' do
    @column.must_be_kind_of TextColumn
  end

  it 'column should containe grid_rects' do
    @column.grid_rects.must_be_kind_of Array
    @column.grid_rects.length.must_equal 55
  end

  it 'should set complex_rect' do
    @column.complex_rect.must_equal true
    @column2.complex_rect.must_equal true
  end

  it 'should return a sugested rect' do
    @column2.sugest_me_a_rect_at(0, 16.0)
  end
  #
  # it 'should return overlapping rects' do
  #   # puts "overlapping_rects"
  #   # @column2.overlapping_rects.each do |rect|
  #   #   puts "rect.rect:#{rect.rect}"
  #   # end
  #   # puts "fully_covered_rects"
  #   # @column2.fully_covered_rects.each do |rect|
  #   #   puts "rect.rect:#{rect.rect}"
  #   # end
  #
  #   puts "@column.current_position:#{@column.current_position}"
  #   @column.overlapping_rects.length.must_equal 13
  # end
  #
  # it 'should draw path from current position' do
  #   puts "@column.current_position:#{@column.current_position}"
  #   @pdf_path = File.dirname(__FILE__) + "/output/text_column_grid_path.pdf"
  #   @tb.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).must_equal true
  #   system("open #{@pdf_path}")
  # end
end

__END__

describe 'GridRect' do
  before do
    @grid = GridRect.new([0,0,200,8])
  end

  it 'should test top_right_position' do
    x, y= @grid.top_right_position
    x.must_equal 200
    y.must_equal 0
  end

  it 'should test top_left_position' do
    x, y= @grid.top_left_position
    x.must_equal 0
    y.must_equal 0
  end

  it 'should test bottom_left_position' do
    x, y= @grid.bottom_left_position
    x.must_equal 0
    y.must_equal 8
  end

  it 'should test bottom_right_position' do
    x, y= @grid.bottom_right_position
    x.must_equal 200
    y.must_equal 8
  end
end


describe 'TextColumn creation' do
  before do
    @tb = TextBox.new(column_count: 2, width:400, height: 700, body_line_height: 18)
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
    grid_rect = @tc.current_grid_rect_at_position(20)
    grid_rect.must_be_kind_of GridRect
    # puts "grid_rect.rect:#{grid_rect.rect}"
  end
end

# describe 'path addition' do
#   before  do
#     @tb = TextBox.new(column_count: 2, width:400, height: 700, body_line_height: 18)
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
describe 'TextColumn creation test' do
  before do
    @tb       = TextColumn.new(:width=>300, :height=>800)
    @path     = "/Users/Shared/rlayout/output/text_column_test.svg"
    @pdf_path = "/Users/Shared/rlayout/output/text_column_test.pdf"
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
    File.exist?(@pdf_path).must_equal true
  end

end
