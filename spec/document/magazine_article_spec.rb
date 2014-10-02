require File.dirname(__FILE__) + "/../spec_helper"

describe 'create magazine_article' do
  before do
    @m = MagazineArticle.new(:title =>"MyMagazine")
  end
  
  it 'should create MagazineArticle' do
    @m.must_be_kind_of MagazineArticle
  end
  
  it 'should create pages' do
    @m.pages.length.must_equal 2
  end
  
  it 'should save' do
    @pdf_path = File.dirname(__FILE__) + "/../output/magazine_article_test.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end
