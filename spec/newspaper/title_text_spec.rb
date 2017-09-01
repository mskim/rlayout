require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create with article' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2017-05-30/1/2"
    @maker          = NewsArticleMaker.new(article_path: @article_path)
    @news_box       = @maker.news_article_box
    @heading        = @news_box.floats.first
  end

  it 'shoule create NewsArticleMaker' do
    assert_equal NewsArticleMaker, @maker.class
    assert_equal NewsArticleBox, @news_box.class
    assert_equal NewsArticleHeading, @heading.class
  end

end
#
# describe 'create TitleText' do
#   before do
#     @tt                 = TitleText.new(string: "this is a title", para_style_name:'title_4_5', width: 500)
#     @line               = @tt.graphics.first
#     @string
#   end
#
#   it 'should create TitleText' do
#     assert_equal TitleText, @tt.class
#     assert_equal 48, @tt.height
#   end
#
#   it 'should create one line' do
#     assert_equal 4, @tt.graphics.length
#   end
# end
