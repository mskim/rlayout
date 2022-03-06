require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create a Page" do
  before do
    @page = RPage.new
    @pdf_path = "/Users/mskim/test_data/page/r_page.pdf"
  end

  it 'should create Page' do
    assert_equal RPage, @page.class 
  end

  it 'shoud have width' do
    assert_equal SIZES['A4'][0], @page.width
  end

  it 'should save pdf' do
    @page.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system "open #{@pdf_path}"
  end

end

