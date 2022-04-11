require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'test EssayBook' do
  before do
    @project_path  = "/Users/mskim/test_data/book/essay_book"
    @essey = Book.new(@project_path)
  end

  it 'should create EssayBook' do
    assert_equal RLayout::Book, @essey.class 
  end

  # it 'should create Seneca' do
  #   assert File.exist?(@pdf_path) 
  #   system "open #{@pdf_path}"
  # end
end
