require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"

describe 'parse book_md ' do
  before do
    # @book_md_path  = "#{ENV["HOME"]}/test_data/book_parser_md/book.md"
    @book_projext_path  = "#{ENV["HOME"]}/Development/tech_media/green_garden"
    @book_md_parser = BookParserMd.new(@book_projext_path)
  end

  it 'should create Book' do
    assert_equal RLayout::BookParserMd, @book_md_parser.class
  end
end
