require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create LeaderTable' do
  before do
    # data_path    = "/Users/mskim/test_data/demo_table/story.md"
    @data = [
      ['찬송', '320', '다같이'],
      ['대표기도', '김성근'],
      ['축가', '거룩한 성', '조수미'],
      ['봉헌', '300', '다같이'],
      ['설교', '마음이 아름다운 사람', '전상출'],
      ['찬송', '500', '다같이'],
      ['this', 'this', 'this'],
      ['this', 'this', 'this'],
      ['bottom', 'this'],
    ]
    @style = {}
    @table        = RLayout::LeaderTable.new( width: 300, height: 400, table_data:@data, table_style: @style)
    @body_row     = @table.graphics[1]
    @cell         = @table.graphics.first.graphics.first
    @second_cell  = @table.graphics.first.graphics[1]
    @pdf_path     = "/Users/mskim/test_data/leader_table/leader_table.pdf"
  end

  it 'should create LeaderTable' do
    assert_equal RLayout::LeaderTable, @table.class 
  end

  it 'should create LeaderTable with given width and height' do
    assert_equal 300, @table.width
    assert_equal 400, @table.height
  end

  it 'should create table with 8 rows' do
    assert_equal 9, @table.graphics.length 
    assert_equal RLayout::LeaderRow, @table.graphics.first.class 
    assert_equal 3, @body_row.graphics.length
    assert_equal 300, @table.graphics.first.width 
    assert_equal 0, @table.graphics.first.x 
    assert_in_delta 0.1, 400/9, @table.graphics.first.height 
    assert_in_delta 0.1, 400/9, @table.graphics[2].height 
  end
  
  it 'should create Cell with Text' do
    assert_equal TextCell, @cell.class
    assert_equal '찬송', @cell.text_string
  end

  it 'should create LeadeCell' do
    # assert_equal Text, @second_cell.class
    assert_equal LeaderCell, @second_cell.class
  end

  it 'should save table pdf' do
    @table.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end

  # it 'should create table with head text' do
  #   @table.graphics.first.graphics.first.string.must_equal "head_one"
  # end

  # it 'should create table with body text' do
  #   @table.graphics[1].graphics.first.string.must_equal "body1_one"
  # end

  # it 'should create head_row' do
  #   @head_row.head_row.must_equal true
  # end
  
  # it 'should create body_row' do
  #   @body_row.head_row.must_equal false
  # end


end


__END__

describe 'create BoxTable' do
  before do
    # data_path    = "/Users/mskim/test_data/demo_table/story.md"
    @data = [
      ['this is title'],
      ['this is title'],
      ['this is cell', 'this is cell', 'this is cell'],
      ['It is a somethig', 'this '],
    ]

    @table        = RLayout::BoxTable.new( width: 200, height: 300, table_data:@data, table_style: @style)
    @body_row     = @table.graphics[1]
    @pdf_path     = "/Users/mskim/test_data/box_ad/box_ad2.pdf"
  end

  it 'should create BoxTable' do
    assert_equal RLayout::BoxTable, @table.class 
  end

  it 'should create BoxTable' do
    assert_equal 200, @table.width
    assert_equal 300, @table.height
  end

  it 'should create table with 8 rows' do
    assert_equal 4, @table.graphics.length 
    assert_equal RLayout::LeaderRow, @table.graphics.first.class 
    assert_equal 200, @table.graphics.first.width 
    assert_equal 0, @table.graphics.first.x 
    assert_in_delta 0.1, 300/4, @table.graphics.first.height 
    assert_in_delta 0.1, 200/3, @table.graphics[1].width 
    assert_equal 300/4, @table.graphics[2].height 
  end
  
  it 'should create TableCell with Text' do
    cell = @table.graphics.first.graphics.first
    assert_equal Text, cell.class
    assert_in_delta 0.1,  500/3, cell.width.round
    assert_equal 'this is title', cell.string
  end

  # it 'should create table with head text' do
  #   @table.graphics.first.graphics.first.string.must_equal "head_one"
  # end

  # it 'should create table with body text' do
  #   @table.graphics[1].graphics.first.string.must_equal "body1_one"
  # end

  # it 'should create head_row' do
  #   @head_row.head_row.must_equal true
  # end
  
  # it 'should create body_row' do
  #   @body_row.head_row.must_equal false
  # end

  it 'should save table pdf' do
    @table.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end

end