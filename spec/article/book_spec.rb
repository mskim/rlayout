require File.dirname(__FILE__) + "/../spec_helper"
require File.dirname(__FILE__) + '/../../lib/rlayout/article/chapter'
require File.dirname(__FILE__) + '/../../lib/rlayout/publication/book'

describe 'parse book folder' do
  before do
    @path = "/Users/mskim/book/pastor"
    @book = Book.new(@path)
  end
  
  it 'shoul convert markdown files to pdf' do
    @book.markdown2pdf
  end
  
  # it 'should create Book' do
  #   @book.must_be_kind_of Book
  # end
  # 
  # it 'shoul convert txt files to markdown files' do
  #   @book.txt2markdown
  # end
  
  # it 'should delete markdown_files' do
  #   @book.delete_markdown_files
  #   
  # end
  # 
end