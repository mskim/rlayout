require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create new book' do
  before do
    @path = "/Users/mskim/demo/demo_book/sample_book"
    @book = Book.new(@path)
  end

  it 'should create Book' do
    @book.must_be_kind_of Book
  end

  it 'should create a folder ' do
    File.exists?(@path).must_equal true
  end

  it 'should add page number to doc_info.yml' do
    @book.update_starting_page
    @book.update_toc
  end
  #
  # it 'should merge pdf_articles ' do
  #   @book.merge_pdf_articles
  # end
end

__END__

describe 'generate pdf' do
  before do
    @path = "/Users/mskim/Dropbox/RLayout/pastor"
    @path = "/Users/mskim/book/pastor"
    @book = Book.new(@path)
  end

  it 'shoul convert markdown files to pdf' do
    # @book.process_markdown_files(:check_time=>true)
    @book.process_markdown_files(:paper_size=>'A5')
    @book.body_matter.must_be_kind_of Array
  end

  it 'should create Book' do
    @book.must_be_kind_of Book
  end
end

# describe 'merge pdf chapters' do
#   before do
#     @path = "/Users/mskim/book/sample_book"
#     # @path = "/Users/mskim/Dropbox/RLayout/pastor"
#
#     @book = Book.new(@path)
#   end
#   it 'should merge pdf' do
#     @book.merge_pdf_chpaters
#   end
# end
#

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
