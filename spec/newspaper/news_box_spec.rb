require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'NewsBox extended_lines ' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/23/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @row            = @news_box.row_count
    @article_bottom_space_in_lines = @news_box.article_bottom_space_in_lines
    @lines_per_grid = @news_box.lines_per_grid
    @original_line_count = @row*@lines_per_grid - @article_bottom_space_in_lines
  end

  it 'should have extended_line_count 0' do
    assert_equal @news_box.extened_line_count, 1
    assert_equal @news_box.pushed_line_count, 0
  end

  it 'should create RColumn with extra line' do
    assert_equal NewsArticleBox, @news_box.class
    assert_equal RColumn, @first_column.class
    assert_equal @original_line_count + @news_box.extened_line_count, @first_column.graphics.length
  end

end

describe 'NewsBox pushed_lines ' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/23/3"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @row            = @news_box.row_count
    @article_bottom_space_in_lines = @news_box.article_bottom_space_in_lines
    @lines_per_grid = @news_box.lines_per_grid
    @original_line_count = @row*@lines_per_grid - @article_bottom_space_in_lines
    @first_column   = @news_box.graphics.first
  end

  it 'should have extended_line_count 0' do
    assert_equal @news_box.pushed_line_count, 1
  end

  it 'should create RColumn with extra line' do
    assert_equal NewsArticleBox, @news_box.class
    assert_equal RColumn, @first_column.class
  end

end
