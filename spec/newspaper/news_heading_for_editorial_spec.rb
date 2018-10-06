require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet NewsBoxMaker for NewsBox with Opinion with 6 column' do
  before do

    @article_path   = "/Users/mskim/Development/rails5/style_guide/doc/23/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
  end

  it 'should create NewsBoxMaker ' do
    assert_equal NewsBoxMaker, @maker.class
  end


end
