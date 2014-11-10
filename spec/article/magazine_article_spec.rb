require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'
require File.dirname(__FILE__) + '/../../lib/rlayout/article/magazine_article'

# describe 'create magazine_article' do
#   before do
#     @m = MagazineArticle.new(:title =>"MyMagazine")
#   end
#   
#   it 'should create MagazineArticle' do
#     @m.must_be_kind_of MagazineArticle
#   end
#   
#   it 'should create pages' do
#     @m.pages.length.must_equal 2
#   end
#   
#   it 'must_be-subclass of Chapter' do
#     @m.must_be_kind_of Chapter
#     @m.chapter_kind.must_equal "magazine_article"
#   end
# end


describe 'create Chapter page with StoryBox' do
  
  before do
    @story_path = "/Users/mskim/chapter/2012-12-18-making-rlayout-for-variable-publishing.markdown"
    @m = MagazineArticle.new(:title =>"Chapter Title", :starts_left=>false, :story_path=>@story_path)    
    @first_page = @m.pages.first
    @heading = @m.pages.first.main_box.heading
  end
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/magazine_article_test.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
  
  it 'should save yml' do    
    @yml_path = File.dirname(__FILE__) + "/../output/magazine_article_test.yml"
    @m.save_yml(@yml_path)
    File.exists?(@yml_path).must_equal true
  end
end
