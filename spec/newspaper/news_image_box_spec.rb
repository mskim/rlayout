require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create NewsBoxMaker with Image' do
  before do
    @article_path   = "/Users/mskim/Development/rails5/style_guide/public/1/issue/2018-07-18/1/1"
    @maker          = NewsBoxMaker.new(article_path: @article_path)
    @news_box       = @maker.news_box
  end

  it 'should create NewsImageBox ' do
    @news_box.must_be_kind_of NewsImageBox
  end


end
