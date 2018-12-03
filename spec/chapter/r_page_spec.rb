require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create a Page" do
  before do
    @page = RPage.new
    @pdf_path = "/Users/Shared/rlayout/pdf_output/r_page.pdf"
  end

  it 'should create Page' do
    @page.must_be_kind_of RPage
  end

  it 'shoud have width' do
    @page.width.must_equal SIZES['A4'][0]
  end

  it 'shoud create main_box' do
    @page.main_box.must_be_kind_of RTextBox
  end

  it 'should save pdf' do
    @page.save_pdf(@pdf_path)
    File.exist?(@pdf_path).must_equal true
    system "open #{@pdf_path}"
  end

end

