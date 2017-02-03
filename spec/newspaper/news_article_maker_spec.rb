require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'creaet document with NewsArticleMaker' do
  before do
    @article_path = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    @article_path = "/Users/mskim/demo/demo_news/1"
    @maker        = NewsArticleMaker.new(article_path: @article_path)
    @news_box     = @maker.news_article_box
    heading       = @news_box.floats.first
  end

  it 'should create MagazineArticleScript' do
     assert @maker.class == NewsArticleMaker
  end
end

__END__
describe 'news_article reading stoy' do
  before do
    @path     = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    @article  = NewsArticleMaker.make_layout(@path)
  end

  it 'should create layout file' do
    @layout_path = @path + "/layout.rb"
    assert File.exist?(@layout_path)
  end
end
