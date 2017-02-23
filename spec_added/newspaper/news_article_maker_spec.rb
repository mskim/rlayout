require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'creaet document with NewsArticleMaker' do
  before do
    # @article_path = "/Users/mskim/Dropbox/OurTownNews/2015-06-12/News/1.story"
    # @article_path = "/Users/mskim/demo/demo_news/1"
    # @article_path = "/Users/mskim/Development/rails5/naeil_article/public/1/1"
    @article_path = "/Users/mskim/Development/rails5/articles/public/current_issue/1/1"
    @svg_path     = @article_path + "/output.svg"
    @maker        = NewsArticleMaker.new(article_path: @article_path)
    @news_box     = @maker.news_article_box
    @heading      = @news_box.floats.first
    @first_column = @news_box.graphics.first
  end

  it 'should create NewsArticleMaker' do
    assert_equal NewsArticleMaker, @maker.class
    assert_equal NewsArticleBox, @news_box.class
    assert_equal Heading, @heading.class
    assert_equal NewsColumn, @first_column.class
  end

  it 'should create lines' do
    assert_equal NewsColumn, @first_column.class
    # @first_column.graphics.each do |line|
    #   puts line.line_string
    # end
  end
  it 'should save svg' do
    assert_equal true, File.exist?(@svg_path)
    # system "open #{@svg_path}"
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
