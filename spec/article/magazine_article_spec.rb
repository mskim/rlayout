require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'
require File.dirname(__FILE__) + '/../../lib/rlayout/article/magazine_article'


describe 'create MagazineChapter with Image' do
  before do
    @story_path = "/Users/mskim/magazine_article/second_article"
    @m = MagazineArticleMaker.new(:starts_left=>false, :story_path=>@story_path, :column_count =>3)    
  end
  
  it 'should crete' do  
    assert @m.class == MagazineArticleMaker  
    @pdf_path = "/Users/Shared/rlayout/output/magazine_article_with_imag.pdf"
  end
  
  # it 'should save yml' do    
  #   @yml_path = "/Users/Shared/rlayout/output/magazine_article_with_imag.yml"
  #   @m.save_yml(@yml_path)
  #   File.exists?(@yml_path).must_equal true
  # end
end

__END__
describe 'create MagazineChapter with Image' do
  before do
    @story_path = "/Users/mskim/magazine/how-to-creaete-soochup2.markdown"
    @m = MagazineArticle.new(:starts_left=>false, :story_path=>@story_path, :column_count =>3)    
  end
  
  it 'should save' do    
    @pdf_path = "/Users/Shared/rlayout/output/magazine_article_with_imag.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
    system("open #{@pdf_path}")
  end
  
  # it 'should save yml' do    
  #   @yml_path = "/Users/Shared/rlayout/output/magazine_article_with_imag.yml"
  #   @m.save_yml(@yml_path)
  #   File.exists?(@yml_path).must_equal true
  # end
end

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
#     @m.article_type.must_equal "magazine_article"
#   end
# end

# describe 'create MagazineChapter page with TextBox' do
#   before do
#     @story_path = "/Users/mskim/magazine/how-to-creaete-soochup.markdown"
#     @m = MagazineArticle.new(:starts_left=>false, :story_path=>@story_path, :column_count =>3, :heading_columns=>2, :article_type=>"magazine_article")    
#     @first_page = @m.pages.first
#     @heading = @m.pages.first.main_box.heading
#   end
#   
#   it 'should save' do    
#     @pdf_path = "/Users/Shared/rlayout/output/magazine_article2.pdf"
#     @m.save_pdf(@pdf_path)
#     File.exists?(@pdf_path).must_equal true
#     system("open #{@pdf_path}")
#   end
#   
#   it 'should save yml' do    
#     @yml_path = "/Users/Shared/rlayout/output/magazine_article2.yml"
#     @m.save_yml(@yml_path)
#     File.exists?(@yml_path).must_equal true
#   end
# end


