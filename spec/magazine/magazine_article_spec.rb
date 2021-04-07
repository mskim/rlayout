require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'overlapping floats' do
  before do
    @article_path   = "/Users/mskim/test_data/magazine/1_article"
    h = {}
    h[:article_path] = @article_path
    @article_maker   = MagazineArticle.new(h)
    @article         = @article_maker.document
  end

  it 'should create MagazineArticle' do
    assert_equal MagazineArticle, @article_maker.class
  end

  it 'should have width,' do
    assert_equal @article.width, 595.28
    assert_equal @article.height, 841.89
    assert_equal @article.column_count, 2
  end

  it 'should have pages' do
    assert_equal RPage, @article.pages.first.class
    assert_equal 2, @article.pages.count
  end

end