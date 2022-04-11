require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test PoetryBook from md' do
  before do
    @project_path  = "/Users/mskim/test_data/book/poetry_book_with_md"
    FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
    @poetry_book = PoetryBook.new(@project_path)
  end

  it 'should create PoetryBook' do
    assert_equal RLayout::PoetryBook, @poetry_book.class 
  end
end


# describe 'test PoetryBook' do
#   before do
#     @project_path  = "/Users/mskim/test_data/book/poetry_book"
#     # @pdf_path  = "/Users/mskim/test_data/book/poetry_book/pdf/"
#     @poetry_book = PoetryBook.new(@project_path)
#   end

#   it 'should create PoetryBook' do
#     assert_equal RLayout::PoetryBook, @poetry_book.class 
#   end

#   # it 'should create Seneca' do
#   #   assert File.exist?(@pdf_path) 
#   #   system "open #{@pdf_path}"
#   # end
# end
