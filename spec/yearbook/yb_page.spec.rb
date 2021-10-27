require File.dirname((File.expand_path __FILE__)) + "/../spec_helper"

describe 'create YbPage even' do
  before do
    @page_path =  "/Users/mskim/test_data/book/yearbook/yb_page_even"
    @pdf_path =  "/Users/mskim/test_data/book/yearbook/yb_page_even/output.pdf"
    @y = YbPage.new(page_path: @page_path, page_number: 12)
  end

  it 'should create folders' do
    assert RLayout::YbPage,  @y.class
    assert_equal 3, @y.graphics.length
  end

  it 'should save PDF ' do
    @y.save_pdf(@pdf_path)
    assert File.exists?(@pdf_path)
    system("open #{@pdf_path}")
  end
end

describe 'create YbPage Odd' do
  before do
    @page_path =  "/Users/mskim/test_data/yearbook/yb_page_odd"
    @pdf_path =  "/Users/mskim/test_data/yearbook/yb_page_odd/output.pdf"
    @y = YbPage.new(page_path: @page_path, page_number: 11)
  end

  it 'should create folders' do
    assert RLayout::YbPage,  @y.class
    assert_equal 3, @y.graphics.length
  end

  it 'should save PDF ' do
    @y.save_pdf(@pdf_path)
    assert File.exists?(@pdf_path)
    system("open #{@pdf_path}")
  end
end