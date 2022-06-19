require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'parse book_txt ' do
  before do
    @book_txt_path  = "#{ENV["HOME"]}/test_data/book_txt_parser/book.txt"
    @book_txt_parser = BookTxtParser.new(@book_txt_path)
  end

  it 'should create Book' do
    assert_equal RLayout::BookTxtParser, @book_txt_parser.class
  end
end
