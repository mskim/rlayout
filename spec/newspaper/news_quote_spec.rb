require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsBoxMaker with Quote' do
  before do
    @article_path   = "/Users/mskim/Development/style_guide/public/1/issue/2019-03-03/20/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
    @news_quote     = @news_box.floats[2]
  end

  it 'should create NewsQuote' do
    assert_equal NewsQuote, @news_quote.class
    # assert_equal TitleText, @news_quote.floats[1].class
  end
end
