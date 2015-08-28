require File.dirname(__FILE__) + "/../spec_helper"

describe 'creaet document with MagazineArticleMaker' do
  before do
    article_path = "/Users/mskim/magazine_article/first_article"
    @doc = MagazineArticleMaker.new(article_path: article_path)
  end
  
  it 'should create MagazineArticleScript' do
    assert @doc.class == MagazineArticleMaker
  end
end