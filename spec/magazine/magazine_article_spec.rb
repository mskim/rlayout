require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"


describe 'overlapping floats' do
  before do
    # @article_path   = "/Users/mskim/demo/demo_magazine/1"
    @article        = MagazineArticle.new()
  end

  it 'should create MagazineArticle' do
    assert_equal MagazineArticle, @article.class
  end

  it 'should have width,' do
    assert_equal @article.page_size, 'A4'
    assert_equal @article.width, 595.28
    assert_equal @article.height, 841.89
  end
  it 'should have pages' do
    assert_equal @article.pages.first.class, RPage
    assert_equal @article.pages.count, 1

  end

end