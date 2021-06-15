require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'testing GridTable' do
  before do

    @pdf_path = "/Users/mskim/test_data/grid_table/output.pdf"
    @csv_path = "/Users/mskim/test_data/grid_table/data.csv"
    @t = GridTable.new(has_head: true, :width=>400, :height=>400,  csv_path: @csv_path, output_path: @pdf_path)
  end

  it 'should create GridTable' do
    assert_equal GridTable, @t.class
    assert_equal 400, @t.width
    assert_equal 400, @t.height
  end

  it 'should create Text cells as members ' do
    # assert 200 > @t.graphics.first.width
    assert_equal RLayout::Text, @t.graphics.first.class
    assert_equal RLayout::Text, @t.graphics.last.class
  end

  it 'should have head_row with elements' do
    assert_equal 4, @t.column
    assert_equal 4, @t.head_row.length
    assert_equal RLayout::Text, @t.head_row.first.class
    assert_equal @t.graphics.length - @t.column , @t.body_cells.length
  end

  it 'should have even_row body_cells' do
    assert_equal 'line_1', @t.head_row.first.text_string
    assert_equal 'line_2', @t.nth_body_row_cells(0).first.text_string
    assert_equal 'line_2', @t.even_body_rows.first.first.text_string
    assert_equal 'line_3', @t.odd_body_rows.first.first.text_string
  end
  
  it 'should save pdf GroupImage' do
    @t.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path) == true
    system "open #{@pdf_path}"
  end
end
