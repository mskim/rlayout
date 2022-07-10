require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'create new book ' do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/quote"
    h = {}
    h[:width] = SIZES['A4'][0]
    h[:height] = SIZES['A4'][1]
    h[:left_margin] = 50
    h[:top_margin] = 50
    h[:right_margin] = 50
    h[:bottom_margin] = 50
    h[:document_path] = @document_path
    h[:starting_page_number] = 14
    h[:body_line_count] = 40
    h[:jpg] = false
    @chapter  = RLayout::Chapter.new(**h)
    @document = @chapter.document
    @pdf_path = "#{ENV["HOME"]}/test_data/quote/chapter.pdf"

  end

  it 'should create Book' do
    assert_equal RLayout::Chapter, @chapter.class
    system "open #{@pdf_path}"
  end
end


__END__
describe 'create buiㅣd book.md' do
before do
  @project_path  = "#{ENV["HOME"]}/test_data/book/paperback_with_book_md"
  # @project_path  = "/Users/mskim/Development/bookcheego/starters/paperback_starter"
  @paperback = Book.new(@project_path)
end

it 'should create Book' do
  assert_equal RLayout::Book, @paperback.class 
end
end

