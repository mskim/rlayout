require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create RDocument" do
  before do
    # @document_path = "#{ENV["HOME"]}/test_data/sample_book/01_chapter"
    @doc = RDocument.new()
  end

  it 'should create RDocument' do
    assert_equal RDocument, @doc.class
  end

  it 'should have a page_size' do
    assert_equal 'A4', @doc.page_size 
  end

  it 'shoud have width' do
    assert_equal SIZES['A4'][0], @doc.width 
  end

  it 'should have pages' do
    assert_equal 1, @doc.pages.length
  end

  it 'should have margins' do
    assert_equal 50, @doc.left_margin 
  end
end

describe "create first page" do
  before do
    @doc = RDocument.new()
    @pages = @doc.pages
    @first_page = @pages.first
  end

  it 'should create a first page' do
    assert_equal  1, @pages.length
  end

  it 'should create a first page' do
    assert_equal RPage, @pages.first.class
  end

  it 'should return first_page_with_text_line' do
    page, line = @doc.first_page_with_text_line
    assert 1, page.page_number
    assert RLineFragment, line.class
    assert 0, line.y
  end

  it 'should save pdf' do
    @pdf_path = "#{ENV["HOME"]}/test_data/book/01_chapter/document.pdf"
    @doc.save_pdf(@pdf_path)
    assert File.exist?(@pdf_path)
    system "open #{@pdf_path}"
  end

end
