require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test PoemBook' do
  before do
    @project_path  = "/Users/mskim/test_data/book/poem_book"
    # @pdf_path  = "/Users/mskim/test_data/book/poem_book/pdf/"
    @poem_book = PoemBook.new(@project_path)
  end

  it 'should create PoemBook' do
    assert_equal RLayout::PoemBook, @poem_book.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
