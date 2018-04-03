require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet document with NewsBoxMaker' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/page_heading/2"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box

  end

  it 'should create NewsArticleBox' do
    assert_equal Container, @news_box.class
  end
end
