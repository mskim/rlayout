require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test EssayBook' do
  before do
    @project_path  = "/Users/mskim/test_data/book/essay_book"
    # @build_path  = "/Users/mskim/test_data/book/essay_book/build"
    # @biild_book_cover_path = @build_path + "/book_cover"
    # @biild_front_matter_path = @build_path + "/front_matter"
    @essey = EssayBook.new(@project_path)
  end

  it 'should create EssayBook' do
    assert_equal RLayout::EssayBook, @essey.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
