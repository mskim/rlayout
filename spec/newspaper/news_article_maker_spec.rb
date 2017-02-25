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
    @first_column_first_line = @first_column.graphics.first
    @tokens = @first_column_first_line.graphics
    @second_column = @news_box.graphics[1]
    @second_column_first_line = @second_column.graphics.first
  end

  it 'should create NewsArticleMaker' do
    assert_equal @news_box.height, @first_column.height
    assert_equal NewsArticleBox, @news_box.class
    assert_equal Heading, @heading.class
    assert_equal 10, @news_box.gutter
  end

  it 'shold create NewsColumn' do
    assert_equal NewsColumn, @first_column.class
    assert_equal 10, @news_box.gutter
    assert_equal @first_column.width, @second_column.width
    assert_equal (@second_column.x - @first_column.width), 15
  end

  it 'should create lines' do
    assert_equal @first_column_first_line.width, @second_column_first_line.width
    assert_equal @first_column_first_line.width, @first_column.width
  end

  it 'should save svg' do
    assert_equal true, File.exist?(@svg_path)
    # system "open #{@svg_path}"
  end

  it 'should create floating image' do
    @image = @news_box.get_image
    assert_equal @news_box.height, @image.height
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
