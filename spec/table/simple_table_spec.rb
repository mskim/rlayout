
require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

# | head_one | head_two | head_three |
# | ---------|--------- | ---------- |
# | body1_one | body1_two | body1_three |
# | body2_one | body2_two | body2_three |
# | body3_one | body3_two | body3_three |

describe 'create simple_table' do
  before do
    story_path    = "/Users/mskim/demo/demo_table/story.md"
    @story        = Story.new(story_path).markdown2para_data
    @para_data    = @story[:paragraphs].first
    @table        = SimpleTable.new(width: 500, height: 600, rows: @para_data[:rows])
    @head_row     = @table.graphics.first
    @body_row     = @table.graphics[1]
    @pdf_path     = "/Users/mskim/demo/demo_table/story.pdf"
  end

  it 'should create SimpleTable' do
    @table.must_be_kind_of RLayout::SimpleTable
  end

  it 'should create SimpleTable' do
    @table.width.must_equal 500
  end

  it 'should create table with 4 rows' do
    @table.graphics.length.must_equal 4
  end
  
  it 'should create table with head first text' do
    @table.graphics.first.graphics.first.string.must_equal "head_one"
  end

  it 'should create table with head text' do
    @table.graphics.first.graphics.first.string.must_equal "head_one"
  end

  it 'should create table with body text' do
    @table.graphics[1].graphics.first.string.must_equal "body1_one"
  end

  it 'should create head_row' do
    @head_row.head_row.must_equal true
  end
  
  it 'should create body_row' do
    @body_row.head_row.must_equal false
  end

  it 'should save table pdf' do
    @table.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system "open #{@pdf_path}"

  end

end