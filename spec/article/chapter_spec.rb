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
#     @pdf_path = File.dirname(__FILE__) + "/../output/chapter_test.pdf"
#     @m.save_pdf(@pdf_path)
#     File.exists?(@pdf_path).must_equal true
#   end
# end

describe 'create Chapter page with StoryBox' do
  before do
    @story_path = "/Users/mskim/chapter/2012-12-18-making-rlayout-for-variable-publishing.markdown"
    @m = Chapter.new(:title =>"Chapter Title", :starts_left=>false, :story_path=>@story_path)
    @first_page = @m.pages.first
    @heading = @m.pages.first.story_box_object.heading
  end
  
  # it 'should create Chapter' do
  #     @m.must_be_kind_of Chapter
  #     @m.pages.length.must_equal 2
  #   end
  #   
  # it 'should create pages' do
  #   @first_page.story_box_object.must_be_kind_of StoryBox
  #   @first_page.story_box_object.floats.length.must_equal 1
  #   @first_page.story_box_object.floats.first.must_be_kind_of Heading
  #   @first_page.story_box_object.graphics.each do |col|
  #     puts col.non_overlapping_frame
  #     col.graphics.first.puts_frame
  #   end
  # end
  
  
  it 'should save' do    
    @pdf_path = File.dirname(__FILE__) + "/../output/chapter_test.pdf"
    @m.save_pdf(@pdf_path)
    File.exists?(@pdf_path).must_equal true
  end
end


