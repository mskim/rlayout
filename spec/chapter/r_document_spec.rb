require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create RDocument" do
  before do
    @doc = RDocument.new()
  end

  it 'should create RDocument' do
    @doc.must_be_kind_of RDocument
  end

  it 'should have a title' do
    @doc.title.must_equal 'untitled'
  end

  it 'should have a page_size' do
    @doc.page_size.must_equal 'A4'
  end

  it 'shoud have width' do
    @doc.width.must_equal SIZES['A4'][0]
  end

  it 'should have pages' do
    @doc.pages.length.must_equal 1
  end

  it 'should have margins' do
    @doc.left_margin.must_equal 50
  end
end

describe "create first page" do
  before do
    @doc = RDocument.new()
    @pages = @doc.pages
    @first_page = @pages.first
  end

  it 'should create a first page' do
    @pages.length.must_equal 1
  end

  it 'should create a first page' do
    @pages.first.must_be_kind_of RPage
  end

  it 'first page should have main_text and heading' do
    @first_page.main_box.must_be_kind_of RTextBox
    @first_page.graphics.length.must_equal 2
  end

  it 'should save pdf' do
    @pdf_path = "/Users/Shared/rlayout/pdf_output/r_document.pdf"
    @doc.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system "open #{@pdf_path}"
  end

end
