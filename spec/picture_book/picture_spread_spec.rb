require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"
include RLayout

describe "create PictureSpread" do
  before do
    @document_path = "#{ENV["HOME"]}/test_data/book/picture_book/02_03"
    @document_path = "#{ENV["HOME"]}/test_data/book/picture_book/16_17"
    @pdf_path = @document_path + "/spread.pdf"
    @doc = PictureSpread.new(document_path: @document_path )
  end

  it 'should create PictureSpread' do
    assert_equal PictureSpread, @doc.class
  end

  it 'should have a page_size' do
    assert_equal 'A4', @doc.page_size 
  end

  it 'should have a two pages' do
    assert_equal 2, @doc.pages.length 
  end

  it 'shoud save pdf' do
    assert File.exist? @pdf_path
    @doc.save_pdf(@pdf_path)
    system "open #{@pdf_path}"
  end
end