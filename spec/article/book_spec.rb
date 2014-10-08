require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/book'


describe 'generate pdf' do
  before do
    @path = "/Users/mskim/book/pastor"
    @book = Book.new(@path)
  end
  
  it 'shoul convert markdown files to pdf' do
    @book.markdown2pdf        
    @book.body_matter.must_be_kind_of Array
  end
  
  it 'should create Book' do
    @book.must_be_kind_of Book
  end
end

# describe 'merge pdf chapters' do
#   before do
#     @path = "/Users/mskim/book/pastor"
#     @book = Book.new(@path)
#   end
#   it 'should merge pdf' do
#     @book.merge_pdf_chpaters
#   end
# end


# describe 'should update update_book_tree' do
#   before do
#     @path = "/Users/mskim/book/pastor"
#     @book = Book.new(@path)
#   end
#   it 'shuld update book_tree file' do
#     @book.update_book_tree
#   end
#   
# end
