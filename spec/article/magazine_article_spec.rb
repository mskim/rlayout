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
describe 'create MagazineChapter page with TextBox' do
  before do
    @story_path = "/Users/mskim/magazine/how-to-creaete-soochup.markdown"
    @m = MagazineArticle.new(:starts_left=>false, :story_path=>@story_path, :column_count =>3, :heading_columns=>2, :chapter_kind=>"magazine_article")    
    @first_page = @m.pages.first
    @heading = @m.pages.first.main_box.heading
  end
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/magazine_article2.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
  
  it 'should save yml' do    
    @yml_path = File.dirname(__FILE__) + "/../output/magazine_article2.yml"
    @m.save_yml(@yml_path)
    File.exists?(@yml_path).must_equal true
  end
end
