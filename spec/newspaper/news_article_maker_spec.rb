require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creaet document with NewsArticleMaker' do
  before do
    @article_path = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    @article_path = "/Users/mskim/demo/demo_news/1"
    @article_path = "/Users/mskim/Development/rails5/naeil_article/public/1/1"
    @maker        = NewsArticleMaker.new(article_path: @article_path)
    @news_box     = @maker.news_article_box
    @heading      = @news_box.floats.first
    @first_column = @news_box.graphics.first
  end

  it 'should create NewsArticleMaker' do
    assert_equal(@maker.class, NewsArticleMaker)
    assert_equal(@news_box.class, NewsArticleBox)
    assert_equal(@heading.class, Heading)
    assert_equal(@first_column.class, TextColumn)
  end

  it 'should create paragraphs' do
    @first_column.graphics.each do |para|
      puts para.para_space_info
    end
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
