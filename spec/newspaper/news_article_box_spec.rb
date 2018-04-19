require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"
#
# describe 'overlapping floats' do
#   before do
#     @ad_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22/1"
#     @maker     = NewsBoxMaker.new(article_path: @ad_path)
#     @article_box    = @maker.news_box
#
#   end
#
#   it 'should have extended_line_count' do
#     assert_equal 1, @article_box.extended_line_count
#   end
#
# end


describe 'overlapping floats' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @article_path   = "/Users/mskim/Development/rails5/page_template/public/current_issue/2/3"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/6/3x4/0"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/1/22/2"
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/22/2"
    @svg_path       = @article_path + "/output.svg"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    puts "@news_box.stroke:#{@news_box.stroke}"
    @heading        = @news_box.floats.first
    @image          = @news_box.floats[1]
    @first_column   = @news_box.graphics.first
    puts "@first_column.stroke:#{@first_column.stroke}"
    @second_column  = @news_box.graphics[1]
    @third_column   = @news_box.graphics[2]
    @overflow_column = @news_box.overflow_column
    @box_width      = (@first_column.width)*3 + (@news_box.gutter)*2
  end

  it 'should create NewsHeadingForArticle' do
    assert_equal NewsArticleBox, @news_box.class
  end
  #
  # it 'should create overflowing_column' do
  #   assert_equal 4, @news_box.graphics.length
  #   assert_equal NewsColumn, @overflow_column.class
  # end
  #
  # it 'should create overflowing_column with many lines' do
  #   assert @overflow_column.graphics.length == 98
  # end

  # it 'heading should have two graphics' do
  #   assert_equal 2, @heading.graphics.length
  # end
  #
  # it 'shold create image_box with multiples of column width' do
  #   assert_equal @box_width + @news_box.gutter, @news_box.width
  # end
  #
  # it 'should collect overlapping floats with column' do
  #   assert_equal @heading, @news_box.overlapping_floats_with_column(@first_column).first
  #   assert_equal @heading, @news_box.overlapping_floats_with_column(@second_column).first
  # end
  #
  # it 'column should have 7 lines per grid - 2 ' do
  #   assert_equal @first_column.graphics.length, 4*7 - 2
  # end
end
