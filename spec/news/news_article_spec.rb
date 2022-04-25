require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'NewsArticle' do
  before do
    @article_path   =  "#{ENV["HOME"]}/test_data/news_page_parser/2022-04-01/01/01/01"
    @article    = NewsArticle.new(document_path: @article_path)
  end

  it 'should create NewsArticle' do
    assert RLayout::NewsArticle,  @article.class
  end


end