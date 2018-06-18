require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'creaet document with NewsBoxMaker' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2018-04-27/22/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path, fill_up_enpty_lines: true)
    @news_box       = @maker.news_box
    @heading        = @news_box.heading
    @title          = @heading.title_object
    @quote_box      = @news_box.quote_box
    @first_column   = @news_box.graphics.first
    @eews_article_box_width = @first_column.width*4 + 10*6
    @first_column_first_line = @first_column.graphics.first
    @tokens         = @first_column_first_line.graphics
    # @second_column  = @news_box.graphics[1]
    # @second_column_first_line = @second_column.graphics.first
    # @third_column   = @news_box.graphics[2]
  end

  it 'should create NewsArticleBox' do
    assert_equal NewsArticleBox, @news_box.class
  end

  it 'should create QouteBox' do
    assert_equal QuoteText, @quote_box.class
  end
end
