require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'



# describe 'create Chapter' do
#   before do
#     @m = Chapter.new(:title =>"Chapter Title", :starts_left=>false)
#   end
#   it 'should create Chapter' do
#     @m.must_be_kind_of Chapter
#   end
#   
#   it 'should create pages' do
#     @m.pages.length.must_equal 2
#   end
#   
#   it 'should save' do
#     @pdf_path = "/Users/Shared/rlayout/output/chapter_test.pdf"
#     @m.save_pdf(@pdf_path)
#     File.exists?(@pdf_path).must_equal true
#   end
# end

describe 'chapter' do
  before do
    @path = "/Users/mskim/book/pastor/001.chapter.markdown"
    @chapter = RLayout::Chapter.new(:paper_size=>'A5', :story_path=>@path)
  end
  
  it 'shold create RLayout::Chapter' do
    assert @chapter.class == RLayout::Chapter
  end
  
  # it 'should save pdf' do
  #   @pdf_path = "/Users/mskim/book/pastor/001.chapter.pdf"
  #   @chapter.save_pdf(@pdf_path)
  #   File.exist?(@pdf_path).should == true
  # end
  
end

__END__
describe 'create Chapter page with TextBox' do
  before do
    @story_path = "/Users/mskim/chapter/2012-12-18-making-rlayout-for-variable-publishing.markdown"
    @story_path = "/Users/mskim/book/pastor/013.chapter.markdown"
    @m = Chapter.new(:title =>"Chapter Title", :paper_size=>'A5', :starts_left=>true, :story_path=>@story_path)    
    @first_page = @m.pages.first
    # @heading = @m.pages.first.graphics.first
    # @heading.puts_frame
  end
  
  # it 'should create Chapter' do
  #      @m.must_be_kind_of Chapter
  #      @m.pages.length.must_equal 2
  # end

  # it 'should create pages' do
  #   @first_page.main_box.must_be_kind_of StoryBox
  #   @first_page.main_box.floats.length.must_equal 1
  #   @first_page.main_box.floats.first.must_be_kind_of Heading
  #   @first_page.main_box.graphics.each do |col|
  #     puts col.non_overlapping_frame
  #     col.graphics.first.
  #   end
  # end
  
  it 'should save' do    
     @pdf_path = "/Users/Shared/rlayout/output/chapter_test.pdf"
     @m.save_pdf(@pdf_path)
     File.exists?(@pdf_path).must_equal true
     system("open #{@pdf_path}")
   end
   
   # it 'should save hash' do
   #   @yml_path = "/Users/Shared/rlayout/output/chapter_test.yml"
   #   @m.save_yml(@yml_path)
   #   File.exists?(@yml_path).must_equal true
   # end
end
