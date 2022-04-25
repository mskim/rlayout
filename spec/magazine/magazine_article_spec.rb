require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'overlapping floats' do
  before do
    @article_path   = "#{ENV["HOME"]}/test_data/magazine/1_article"
    h = {}
    h[:document_path] = @article_path
    @article_maker  = MagazineArticle.new(h)
    @article        = @article_maker.document
    @pdf_path       = @article_path + '/article.pdf'
  end

  it 'should create MagazineArticle' do
    assert_equal MagazineArticle, @article_maker.class
  end

  it 'should have width,' do
    assert_equal 595.28, @article.width
    assert_equal 841.89, @article.height
    assert_equal 3, @article.column_count
  end

  it 'should have pages' do
    assert_equal RPage, @article.pages.first.class
    assert_equal 2, @article.pages.count
  end

  it 'should save pdf ' do
    assert File.exist?(@pdf_path)
    system("open #{@pdf_path}")
  end
end