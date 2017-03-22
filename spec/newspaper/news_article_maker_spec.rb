require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creaet document with NewsArticleMaker' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @article_path   = "/Users/mskim/Development/rails5/page_template/public/current_issue/2/3"
    @svg_path       = @article_path + "/output.svg"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @heading        = @news_box.floats.first
    @title          = @heading.title_object
    @first_column   = @news_box.graphics.first
    @eews_article_box_width = @first_column.width*3 + 10*3
    @first_column_first_line = @first_column.graphics.first
    @tokens         = @first_column_first_line.graphics
    @second_column  = @news_box.graphics[1]
    @second_column_first_line = @second_column.graphics.first
    @third_column   = @news_box.graphics[2]
  end

  it 'should create NewsArticleMaker' do
    assert_equal @news_box.height, @first_column.height
    assert_equal @heading.class, NewsArticleHeading
    assert_equal @news_box.gutter, 10
  end

  it 'should create NewsArticleBox' do
    assert_equal NewsArticleBox, @news_box.class
    assert_equal @eews_article_box_width, @news_box.width

  end

  it 'should create NewsArtcicleHeading' do
    assert_equal NewsArticleHeading, @heading.class
    assert_equal Text, @title.class
  end

  it 'should create NewsArticleBox subtitle float' do
    assert_equal 2, @news_box.floats.length
    assert_equal Text, @news_box.floats[1].class
  end
#   it 'shold create NewsColumn' do
#     assert_equal NewsColumn, @first_column.class
#     assert_equal 10, @news_box.gutter
#     assert_equal @first_column.width, @second_column.width
#     assert_equal (@second_column.x - @first_column.width), 15
#     assert_equal @first_column.graphics.length, 30
#   end
#
#   it 'should create lines' do
#     assert_equal @first_column_first_line.width, @second_column_first_line.width
#     assert_equal @first_column_first_line.width, @first_column.width
#     assert_equal @first_column.graphics.length, @third_column.graphics.length
#     assert_equal @first_column_first_line.height, @first_column.height/30
#   end
#
#   it 'should layout tokens' do
#     assert_equal @first_column_first_line.graphics.length, 0
#     assert  @second_column_first_line.graphics.length, 0
#   end
#
#   it 'should save svg' do
#     assert_equal true, File.exist?(@svg_path)
#     # system "open #{@svg_path}"
#   end
#
#
end
