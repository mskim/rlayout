require File.dirname(File.expand_path(__FILE__)) + "/../spec_helper"


describe 'create Seneca' do
  before do
    @document_path  = "#{ENV["HOME"]}/test_data/book_cover/seneca"
    @pdf_path = "#{ENV["HOME"]}/test_data/book_cover/seneca/output.pdf"

    @document_path  = "#{ENV["HOME"]}/test_data/book_cover/build/book_cover/seneca"
    @pdf_path       = "#{ENV["HOME"]}/test_data/book_cover/build/book_cover/seneca/output.pdf"
    # @pdf_path = "#{ENV["HOME"]}/test_data/book_cover/seneca/output.pdf"
    FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
    @seneca = Seneca.new(document_path: @document_path, height: 41)
  end

  it 'should create Seneca' do
    assert_equal RLayout::Seneca, @seneca.class 
  end

  it 'should create Seneca' do
    assert File.exist?(@pdf_path) 
    system "open #{@pdf_path}"
  end
end
