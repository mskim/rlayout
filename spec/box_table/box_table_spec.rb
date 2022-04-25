require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create BoxTable' do
  before do
    # data_path    = "#{ENV["HOME"]}/test_data/demo_table/story.md"
    @data = [
      ['this is cell', 'this is cell', 'this is cell'],
      ['It is a somethig', 'this ', 'this is a cell'],
      ['this', 'this', 'this'],
      ['this', 'this', 'this'],
      ['this', 'this', 'this'],
      ['this', 'this', 'this'],
      ['this', 'this', 'this'],
      ['bottom', 'this', 'this'],
    ]
    @style = {}
    @table        = RLayout::BoxTable.new( width: 400, height: 500, table_data:@data, table_style: @style)
    @body_row     = @table.graphics[1]
    @cell         = @table.graphics.first.graphics.first
    @pdf_path     = "#{ENV["HOME"]}/test_data/box_ad/box_ad1.pdf"
  end

  it 'should create BoxTable' do
    assert_equal RLayout::BoxTable, @table.class 
  end

  it 'should create BoxTable' do
    assert_equal 400, @table.width
    assert_equal 500, @table.height
  end

  it 'should create table with 8 rows' do
    assert_equal 8, @table.graphics.length 
    assert_equal RLayout::BoxTableRow, @table.graphics.first.class 
    assert_equal 400, @table.graphics.first.width 
    assert_equal 0, @table.graphics.first.x 
    assert_in_delta 0.1, 500/8, @table.graphics.first.height 
    assert_in_delta 0.1, 500/8, @table.graphics[2].height 
  end
  
  it 'should create TableCell' do
    assert_equal TextCell, @cell.class
    # assert_in_delta 0.1,  400/3, @cell.width.round
    assert_equal  400/3, @cell.width.round
    assert_equal 'this is cell', @cell.text_string
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
    # data_path    = "#{ENV["HOME"]}/test_data/demo_table/story.md"
    @data = [
      ['this is title'],
      ['this is title'],
      ['this is cell', 'this is cell', 'this is cell'],
      ['It is a somethig', 'this '],
    ]

    @table        = RLayout::BoxTable.new( width: 200, height: 300, table_data:@data, table_style: @style)
    @body_row     = @table.graphics[1]
    @pdf_path     = "#{ENV["HOME"]}/test_data/box_ad/box_ad2.pdf"
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
    assert_equal RLayout::BoxTableRow, @table.graphics.first.class 
    assert_equal 200, @table.graphics.first.width 
    assert_equal 0, @table.graphics.first.x 
    assert_in_delta 0.1, 300/4, @table.graphics.first.height 
    assert_in_delta 0.1, 200/3, @table.graphics[1].width 
    assert_equal 300/4, @table.graphics[2].height 
  end
  
  it 'should create TableCell' do
    cell = @table.graphics.first.graphics.first
    assert_equal TextCell, cell.class
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